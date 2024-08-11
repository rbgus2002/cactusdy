package ssu.groupstudy.domain.auth.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.api.user.vo.*;
import ssu.groupstudy.domain.auth.exception.InvalidLoginException;
import ssu.groupstudy.domain.auth.param.JwtTokenParam;
import ssu.groupstudy.domain.auth.security.jwt.JwtProvider;
import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.notification.service.FcmTokenService;
import ssu.groupstudy.domain.notification.service.FcmTopicSubscribeService;
import ssu.groupstudy.domain.study.service.ExampleStudyCreateService;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.exception.PhoneNumberExistsException;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;
import ssu.groupstudy.global.util.ImageManager;
import ssu.groupstudy.global.util.MessageUtils;
import ssu.groupstudy.global.util.RedisUtils;

import java.io.IOException;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class AuthService {
    private final UserEntityRepository userEntityRepository;
    private final FcmTokenService fcmTokenService;
    private final FcmTopicSubscribeService fcmTopicSubscribeService;
    private final ExampleStudyCreateService exampleStudyCreateService;

    private final PasswordEncoder passwordEncoder;
    private final JwtProvider jwtProvider;
    private final MessageUtils messageUtils;
    private final RedisUtils redisUtils; // [2024-07-28:최규현] TODO: @Cacheable 적용
    private final ImageManager imageManager;
    private final Long THREE_MINUTES = 60 * 3L;
    private final int VERIFICATION_CODE_LENGTH = 6;


    @Transactional
    public JwtTokenParam signIn(SignInReqVo request) {
        UserEntity user = userEntityRepository.findByPhoneNumber(request.getPhoneNumber())
                .orElseThrow(() -> new InvalidLoginException(ResultCode.INVALID_LOGIN));
        validatePassword(request.getPassword(), user.getPassword());

        fcmTokenService.saveFcmToken(request.getFcmToken(), user);
        fcmTopicSubscribeService.subscribeAllUserTopic(user);
        fcmTopicSubscribeService.subscribeParticipatingStudiesTopic(user);

        String jwtToken = jwtProvider.createToken(user.getPhoneNumber(), user.getRoles());
        return JwtTokenParam.of(user.getUserId(), jwtToken);
    }

    private void validatePassword(String requestPassword, String userPassword) {
        if (!passwordEncoder.matches(requestPassword, userPassword)) {
            throw new InvalidLoginException(ResultCode.INVALID_LOGIN);
        }
    }

    @Transactional
    public Long signUp(SignUpReqVo request, MultipartFile image) throws IOException {
        checkPhoneNumberExist(request.getPhoneNumber());

        UserEntity user = processUserSaving(request, image);

        exampleStudyCreateService.createExampleStudy(user);

        return user.getUserId();
    }

    private void checkPhoneNumberExist(String phoneNumber) {
        if (userEntityRepository.existsByPhoneNumber(phoneNumber)) {
            throw new PhoneNumberExistsException(ResultCode.DUPLICATE_PHONE_NUMBER);
        }
    }

    private UserEntity processUserSaving(SignUpReqVo request, MultipartFile image) throws IOException {
        String password = passwordEncoder.encode(request.getPassword());
        UserEntity user = request.toEntity(password);
        user.addUserRole();
        user = userEntityRepository.save(user);

        imageManager.updateImage(user, image);
        return user;
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

    public boolean verifyCode(UserSignUpVerifyReqVo request) {
        String retrievedPhoneNumber = getPhoneNumberFromCode(request);
        boolean isValidCode = isSamePhoneNumber(request.getPhoneNumber(), retrievedPhoneNumber);
        if (isValidCode) {
            processVerificationSuccess(request.getCode());
        }
        return isValidCode;
    }

    private String getPhoneNumberFromCode(UserSignUpVerifyReqVo request) {
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
        user.resetPassword(password);
    }
}
