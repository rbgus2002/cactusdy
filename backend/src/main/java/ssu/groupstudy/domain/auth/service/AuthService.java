package ssu.groupstudy.domain.auth.service;

import lombok.extern.slf4j.Slf4j;
import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.auth.dto.request.MessageRequest;
import ssu.groupstudy.domain.auth.dto.request.PasswordResetRequest;
import ssu.groupstudy.domain.auth.dto.request.VerifyRequest;
import ssu.groupstudy.domain.auth.exception.InvalidLoginException;
import ssu.groupstudy.domain.auth.security.jwt.JwtProvider;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignInRequest;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.dto.response.SignInResponse;
import ssu.groupstudy.domain.user.exception.PhoneNumberExistsException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.util.RedisUtils;

@Service
@Transactional(readOnly = true)
@Slf4j
public class AuthService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtProvider jwtProvider;
    private final DefaultMessageService messageService;
    private final RedisUtils redisUtils;
    @Value("${coolsms.api.fromNum}")
    private String fromNum;
    private final Long THREE_MINUTES = 60 * 3L;
    private final int VERIFICATION_CODE_LENGTH = 6;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtProvider jwtProvider, RedisUtils redisUtils,
                       @Value("${coolsms.api.key}") String apiKey, @Value("${coolsms.api.secret.key}") String apiSecretKey, @Value("${coolsms.api.domain}") String domain) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtProvider = jwtProvider;
        this.redisUtils = redisUtils;
        this.messageService = NurigoApp.INSTANCE.initialize(apiKey, apiSecretKey, domain);
    }

    @Transactional
    public SignInResponse signIn(SignInRequest request) {
        User user = userRepository.findByPhoneNumber(request.getPhoneNumber())
                .orElseThrow(() -> new InvalidLoginException(ResultCode.INVALID_LOGIN));
        validatePassword(request, user);
        user.updateActivateDate();

        return SignInResponse.of(user, jwtProvider.createToken(user.getPhoneNumber(), user.getRoles()));
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
        assertPhoneNumberDoesNotExistOrThrow(request.getPhoneNumber());
        sendMessage(request);
    }

    public void sendMessageToResetPassword(MessageRequest request){
        assertPhoneNumberDoesExistOrThrow(request.getPhoneNumber());
        sendMessage(request);
    }

    private void assertPhoneNumberDoesExistOrThrow(String phoneNumber) {
        if (!userRepository.existsByPhoneNumber(phoneNumber)) {
            throw new PhoneNumberExistsException(ResultCode.PHONE_NUMBER_NOT_FOUND);
        }
    }

    private void sendMessage(MessageRequest request) {
        Message message = createMessage(request);
        SingleMessageSentResponse response = messageService.sendOne(new SingleMessageSendingRequest(message));
        log.info("message : {}", response);
    }

    private Message createMessage(MessageRequest request) {
        Message message = initMessage(request);
        handleVerificationMessage(message);
        return message;
    }

    private Message initMessage(MessageRequest request) {
        Message message = new Message();
        message.setFrom(fromNum);
        message.setTo(request.getPhoneNumber());
        return message;
    }

    private void handleVerificationMessage(Message message) {
        String code = RandomStringUtils.randomNumeric(VERIFICATION_CODE_LENGTH);
        saveCodeToRedis(code, message.getTo());
        String verificationMessage = String.format("[GroupStudy] 인증번호 : %s", code); // TODO : 대괄호 안 문구 앱 이름으로 변경
        message.setText(verificationMessage);
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
