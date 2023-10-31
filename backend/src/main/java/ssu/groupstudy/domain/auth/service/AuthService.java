package ssu.groupstudy.domain.auth.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.auth.dto.request.MessageRequest;
import ssu.groupstudy.domain.auth.dto.request.PasswordResetRequest;
import ssu.groupstudy.domain.auth.dto.request.VerifyRequest;
import ssu.groupstudy.domain.auth.exception.InvalidLoginException;
import ssu.groupstudy.domain.auth.security.jwt.JwtProvider;
import ssu.groupstudy.domain.notification.domain.event.AllUserTopicSubscribeEvent;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignInRequest;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.dto.response.SignInResponse;
import ssu.groupstudy.domain.user.exception.PhoneNumberExistsException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.util.MessageUtils;
import ssu.groupstudy.global.util.RedisUtils;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class AuthService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtProvider jwtProvider;
    private final MessageUtils messageUtils;
    private final RedisUtils redisUtils;
    private final ApplicationEventPublisher eventPublisher;
    private final Long THREE_MINUTES = 60 * 3L;
    private final int VERIFICATION_CODE_LENGTH = 6;


    @Transactional
    public SignInResponse signIn(SignInRequest request) {
        User user = userRepository.findByPhoneNumber(request.getPhoneNumber())
                .orElseThrow(() -> new InvalidLoginException(ResultCode.INVALID_LOGIN));
        validatePassword(request, user);
        handleSuccessfulLogin(request, user);
        return SignInResponse.of(user, jwtProvider.createToken(user.getPhoneNumber(), user.getRoles()));
    }

    private void handleSuccessfulLogin(SignInRequest request, User user) {
        user.updateActivateDate();
        handleFcmToken(request, user);
    }

    private void handleFcmToken(SignInRequest request, User user) {
        user.addFcmToken(request.getFcmToken());
        eventPublisher.publishEvent(new AllUserTopicSubscribeEvent(user));
    }

    private void validatePassword(SignInRequest request, User user) {
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new InvalidLoginException(ResultCode.INVALID_LOGIN);
        }
    }

    @Transactional
    public Long signUp(SignUpRequest request) {
        assertPhoneNumberDoesNotExistOrThrow(request.getPhoneNumber());
        User user = request.toEntity(passwordEncoder);
        user.addUserRole();
        return userRepository.save(user).getUserId();
    }

    private void assertPhoneNumberDoesNotExistOrThrow(String phoneNumber) {
        if (userRepository.existsByPhoneNumber(phoneNumber)) {
            throw new PhoneNumberExistsException(ResultCode.DUPLICATE_PHONE_NUMBER);
        }
    }

    public void sendMessageToSignUp(MessageRequest request) {
        String phoneNumber = request.getPhoneNumber();
        assertPhoneNumberDoesNotExistOrThrow(phoneNumber);

        String verificationMessage = generateVerificationMessage(phoneNumber);
        messageUtils.sendMessage(phoneNumber, verificationMessage);
    }

    public void sendMessageToResetPassword(MessageRequest request){
        String phoneNumber = request.getPhoneNumber();
        assertPhoneNumberDoesExistOrThrow(phoneNumber);

        String verificationMessage = generateVerificationMessage(phoneNumber);
        messageUtils.sendMessage(phoneNumber, verificationMessage);
    }

    private String generateVerificationMessage(String phoneNumber) {
        String code = RandomStringUtils.randomNumeric(VERIFICATION_CODE_LENGTH);
        saveCodeToRedis(code, phoneNumber);
        return String.format("[GroupStudy] 인증번호 : %s", code); // TODO : 대괄호 안 문구 앱 이름으로 변경
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
        if(isValidCode){
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
