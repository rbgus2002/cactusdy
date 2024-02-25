package ssu.groupstudy.domain.auth.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.auth.dto.request.MessageRequest;
import ssu.groupstudy.domain.auth.dto.request.PasswordResetRequest;
import ssu.groupstudy.domain.auth.dto.request.VerifyRequest;
import ssu.groupstudy.domain.auth.exception.InvalidLoginException;
import ssu.groupstudy.domain.auth.security.jwt.JwtProvider;
import ssu.groupstudy.domain.notification.domain.event.subscribe.AllUserTopicSubscribeEvent;
import ssu.groupstudy.domain.notification.domain.event.subscribe.StudyTopicSubscribeEvent;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.repository.ParticipantRepository;
import ssu.groupstudy.domain.study.service.ExampleStudyCreateService;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignInRequest;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.dto.response.SignInResponse;
import ssu.groupstudy.domain.user.exception.PhoneNumberExistsException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.util.ImageManager;
import ssu.groupstudy.global.util.MessageUtils;
import ssu.groupstudy.global.util.RedisUtils;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class AuthService {
    private final UserRepository userRepository;
    private final ParticipantRepository participantRepository;
    private final ExampleStudyCreateService exampleStudyCreateService;
    private final PasswordEncoder passwordEncoder;
    private final JwtProvider jwtProvider;
    private final MessageUtils messageUtils;
    private final RedisUtils redisUtils;
    private final ImageManager imageManager;
    private final ApplicationEventPublisher eventPublisher;
    private final Long THREE_MINUTES = 60 * 3L;
    private final int VERIFICATION_CODE_LENGTH = 6;


    @Transactional
    public SignInResponse signIn(SignInRequest request) {
        User user = userRepository.findByPhoneNumber(request.getPhoneNumber())
                .orElseThrow(() -> new InvalidLoginException(ResultCode.INVALID_LOGIN));
        validateLogin(request, user);
        handleSuccessfulLogin(request, user);
        return SignInResponse.of(user, jwtProvider.createToken(user.getPhoneNumber(), user.getRoles()));
    }

    private void validateLogin(SignInRequest request, User user) {
        validatePassword(request, user);
        validateDelete(user);
    }

    private void validatePassword(SignInRequest request, User user) {
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new InvalidLoginException(ResultCode.INVALID_LOGIN);
        }
    }

    private void validateDelete(User user) {
        if (user.isDeleted()) {
            throw new InvalidLoginException(ResultCode.INVALID_LOGIN);
        }
    }

    private void handleSuccessfulLogin(SignInRequest request, User user) {
        handleFcmToken(request, user);
    }

    private void handleFcmToken(SignInRequest request, User user) {
        if(!user.existFcmToken(request.getFcmToken())){
            user.addFcmToken(request.getFcmToken());
            eventPublisher.publishEvent(new AllUserTopicSubscribeEvent(user));
            subscribeParticipatingStudies(user);
        }
    }

    private void subscribeParticipatingStudies(User user) {
        List<Study> participatingStudies = participantRepository.findByUserOrderByCreateDate(user).stream()
                .map(Participant::getStudy)
                .collect(Collectors.toList());
        for (Study study : participatingStudies) {
            eventPublisher.publishEvent(new StudyTopicSubscribeEvent(user, study));
        }
    }

    @Transactional
    public Long signUp(SignUpRequest request, MultipartFile image) throws IOException {
        checkPhoneNumberExist(request.getPhoneNumber());
        User user = processUserSaving(request);
        imageManager.updateImage(user, image);
        exampleStudyCreateService.createExampleStudy(user);

        return user.getUserId();
    }

    private User processUserSaving(SignUpRequest request) {
        String password = passwordEncoder.encode(request.getPassword());
        User user = request.toEntity(password);
        user.addUserRole();
        return userRepository.save(user);
    }

    private void checkPhoneNumberExist(String phoneNumber) {
        if (userRepository.existsByPhoneNumber(phoneNumber)) {
            throw new PhoneNumberExistsException(ResultCode.DUPLICATE_PHONE_NUMBER);
        }
    }

    public void sendMessageToSignUp(MessageRequest request) {
        String phoneNumber = request.getPhoneNumber();
        checkPhoneNumberExist(phoneNumber);

        String verificationMessage = generateVerificationMessage(phoneNumber);
        messageUtils.sendMessage(phoneNumber, verificationMessage);
    }

    public void sendMessageToResetPassword(MessageRequest request) {
        String phoneNumber = request.getPhoneNumber();
        assertPhoneNumberDoesExistOrThrow(phoneNumber);

        String verificationMessage = generateVerificationMessage(phoneNumber);
        messageUtils.sendMessage(phoneNumber, verificationMessage);
    }

    private String generateVerificationMessage(String phoneNumber) {
        String code = RandomStringUtils.randomNumeric(VERIFICATION_CODE_LENGTH);
        saveCodeToRedis(code, phoneNumber);
        return String.format("[뜨끔] 인증번호 : %s", code);
    }

    private void assertPhoneNumberDoesExistOrThrow(String phoneNumber) {
        if (!userRepository.existsByPhoneNumber(phoneNumber)) {
            throw new PhoneNumberExistsException(ResultCode.PHONE_NUMBER_NOT_FOUND);
        }
    }

    private void saveCodeToRedis(String code, String phoneNumber) {
        redisUtils.setDataExpire(code, phoneNumber, THREE_MINUTES); // KEY : code, VALUE : phoneNumber
    }

    public boolean verifyCode(VerifyRequest request) {
        String retrievedPhoneNumber = getPhoneNumberFromCode(request);
        boolean isValidCode = isSamePhoneNumber(request.getPhoneNumber(), retrievedPhoneNumber);
        if (isValidCode) {
            processVerificationSuccess(request.getCode());
        }
        return isValidCode;
    }

    private String getPhoneNumberFromCode(VerifyRequest request) {
        return redisUtils.getData(request.getCode());
    }

    private boolean isSamePhoneNumber(String requestPhoneNum, String redisPhoneNumber) {
        return requestPhoneNum.equals(redisPhoneNumber);
    }

    private void processVerificationSuccess(String key) {
        redisUtils.deleteData(key);
    }

    @Transactional
    public void resetPassword(PasswordResetRequest request) {
        User user = userRepository.findByPhoneNumber(request.getPhoneNumber())
                .orElseThrow(() -> new InvalidLoginException(ResultCode.USER_NOT_FOUND));
        String password = passwordEncoder.encode(request.getNewPassword());
        user.setPassword(password);
    }
}
