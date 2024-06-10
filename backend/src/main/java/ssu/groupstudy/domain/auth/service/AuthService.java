package ssu.groupstudy.domain.auth.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.api.user.vo.MessageReqVo;
import ssu.groupstudy.api.user.vo.PasswordResetReqVo;
import ssu.groupstudy.api.user.vo.VerifyReqVo;
import ssu.groupstudy.domain.auth.exception.InvalidLoginException;
import ssu.groupstudy.domain.auth.security.jwt.JwtProvider;
import ssu.groupstudy.domain.notification.event.subscribe.AllUserTopicSubscribeEvent;
import ssu.groupstudy.domain.notification.event.subscribe.StudyTopicSubscribeEvent;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.repository.ParticipantEntityRepository;
import ssu.groupstudy.domain.study.service.ExampleStudyCreateService;
import ssu.groupstudy.api.user.vo.SignUpReqVo;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.api.user.vo.SignInReqVo;
import ssu.groupstudy.api.user.vo.SignInResVo;
import ssu.groupstudy.domain.user.exception.PhoneNumberExistsException;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;
import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.common.util.ImageManager;
import ssu.groupstudy.domain.common.util.MessageUtils;
import ssu.groupstudy.domain.common.util.RedisUtils;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class AuthService {
    private final UserEntityRepository userEntityRepository;
    private final ParticipantEntityRepository participantEntityRepository;
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
    public SignInResVo signIn(SignInReqVo request) {
        UserEntity user = userEntityRepository.findByPhoneNumber(request.getPhoneNumber())
                .orElseThrow(() -> new InvalidLoginException(ResultCode.INVALID_LOGIN));
        validateLogin(request, user);
        handleSuccessfulLogin(request, user);
        return SignInResVo.of(user, jwtProvider.createToken(user.getPhoneNumber(), user.getRoles()));
    }

    private void validateLogin(SignInReqVo request, UserEntity user) {
        validatePassword(request, user);
        validateDelete(user);
    }

    private void validatePassword(SignInReqVo request, UserEntity user) {
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new InvalidLoginException(ResultCode.INVALID_LOGIN);
        }
    }

    private void validateDelete(UserEntity user) {
        if (user.isDeleted()) {
            throw new InvalidLoginException(ResultCode.INVALID_LOGIN);
        }
    }

    private void handleSuccessfulLogin(SignInReqVo request, UserEntity user) {
        handleFcmToken(request, user);
    }

    private void handleFcmToken(SignInReqVo request, UserEntity user) {
        if(!user.existFcmToken(request.getFcmToken())){
            user.addFcmToken(request.getFcmToken());
            eventPublisher.publishEvent(new AllUserTopicSubscribeEvent(user));
            subscribeParticipatingStudies(user);
        }
    }

    private void subscribeParticipatingStudies(UserEntity user) {
        List<StudyEntity> participatingStudies = participantEntityRepository.findByUserOrderByCreateDate(user).stream()
                .map(ParticipantEntity::getStudy)
                .collect(Collectors.toList());
        for (StudyEntity study : participatingStudies) {
            eventPublisher.publishEvent(new StudyTopicSubscribeEvent(user, study));
        }
    }

    @Transactional
    public Long signUp(SignUpReqVo request, MultipartFile image) throws IOException {
        checkPhoneNumberExist(request.getPhoneNumber());
        UserEntity user = processUserSaving(request);
        imageManager.updateImage(user, image);
        exampleStudyCreateService.createExampleStudy(user);

        return user.getUserId();
    }

    private UserEntity processUserSaving(SignUpReqVo request) {
        String password = passwordEncoder.encode(request.getPassword());
        UserEntity user = request.toEntity(password);
        user.addUserRole();
        return userEntityRepository.save(user);
    }

    private void checkPhoneNumberExist(String phoneNumber) {
        if (userEntityRepository.existsByPhoneNumber(phoneNumber)) {
            throw new PhoneNumberExistsException(ResultCode.DUPLICATE_PHONE_NUMBER);
        }
    }

    public void sendMessageToSignUp(MessageReqVo request) {
        String phoneNumber = request.getPhoneNumber();
        checkPhoneNumberExist(phoneNumber);

        String verificationMessage = generateVerificationMessage(phoneNumber);
        messageUtils.sendMessage(phoneNumber, verificationMessage);
    }

    public void sendMessageToResetPassword(MessageReqVo request) {
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
        if (!userEntityRepository.existsByPhoneNumber(phoneNumber)) {
            throw new PhoneNumberExistsException(ResultCode.PHONE_NUMBER_NOT_FOUND);
        }
    }

    private void saveCodeToRedis(String code, String phoneNumber) {
        redisUtils.setDataExpire(code, phoneNumber, THREE_MINUTES); // KEY : code, VALUE : phoneNumber
    }

    public boolean verifyCode(VerifyReqVo request) {
        String retrievedPhoneNumber = getPhoneNumberFromCode(request);
        boolean isValidCode = isSamePhoneNumber(request.getPhoneNumber(), retrievedPhoneNumber);
        if (isValidCode) {
            processVerificationSuccess(request.getCode());
        }
        return isValidCode;
    }

    private String getPhoneNumberFromCode(VerifyReqVo request) {
        return redisUtils.getData(request.getCode());
    }

    private boolean isSamePhoneNumber(String requestPhoneNum, String redisPhoneNumber) {
        return requestPhoneNum.equals(redisPhoneNumber);
    }

    private void processVerificationSuccess(String key) {
        redisUtils.deleteData(key);
    }

    @Transactional
    public void resetPassword(PasswordResetReqVo request) {
        UserEntity user = userEntityRepository.findByPhoneNumber(request.getPhoneNumber())
                .orElseThrow(() -> new InvalidLoginException(ResultCode.USER_NOT_FOUND));
        String password = passwordEncoder.encode(request.getNewPassword());
        user.setPassword(password);
    }
}
