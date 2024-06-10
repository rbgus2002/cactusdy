package ssu.groupstudy.domain.auth.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.security.crypto.password.PasswordEncoder;
import ssu.groupstudy.domain.auth.exception.InvalidLoginException;
import ssu.groupstudy.domain.auth.security.jwt.JwtProvider;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.study.repository.ParticipantEntityRepository;
import ssu.groupstudy.domain.study.service.ExampleStudyCreateService;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.api.user.vo.SignInReqVo;
import ssu.groupstudy.domain.user.exception.PhoneNumberExistsException;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;
import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.global.util.ImageManager;
import ssu.groupstudy.global.util.MessageUtils;
import ssu.groupstudy.global.util.S3Utils;

import java.io.IOException;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class AuthServiceTest extends ServiceTest {
    @InjectMocks
    private AuthService authService;
    @Mock
    private ExampleStudyCreateService exampleStudyCreateService;
    @Mock
    private UserEntityRepository userEntityRepository;
    @Mock
    private ParticipantEntityRepository participantEntityRepository;
    @Mock
    private MessageUtils messageUtils;
    @Mock
    private PasswordEncoder passwordEncoder;
    @Mock
    private JwtProvider jwtProvider;
    @Mock
    private S3Utils s3Utils;
    @Mock
    private ApplicationEventPublisher eventPublisher;
    @Mock
    private ImageManager imageManager;


    @Nested
    class 회원가입 {
        @Test
        @DisplayName("중복되는 핸드폰번호가 존재하면 예외를 던진다")
        void emailDuplicated() {
            // given
            doReturn(true).when(userEntityRepository).existsByPhoneNumber(any(String.class));

            // when, then
            softly.assertThatThrownBy(() -> authService.signUp(최규현SignUpReqVo, null))
                    .isInstanceOf(PhoneNumberExistsException.class)
                    .hasMessage(ResultCode.DUPLICATE_PHONE_NUMBER.getMessage());
        }

        @Test
        @DisplayName("회원가입 성공")
        void success() throws IOException {
            // given
            doReturn(false).when(userEntityRepository).existsByPhoneNumber(any(String.class));
            doReturn(최규현).when(userEntityRepository).save(any(UserEntity.class));

            // when
            final Long userId = authService.signUp(최규현SignUpReqVo, null);

            // then
            softly.assertThat(userId).isNotNull();
        }
    }

    @Nested
    class SignIn{
        private final SignInReqVo request = SignInReqVo.builder()
                .phoneNumber("")
                .password("valid")
                .fcmToken("")
                .build();

        private final SignInReqVo requestInvalidPassword = SignInReqVo.builder()
                .phoneNumber("")
                .password("invalid")
                .fcmToken("fcm token")
                .build();

        @Test
        @DisplayName("휴대폰번호가 존재하지 않으면 로그인에 실패한다.")
        void phoneNumberNotFound(){
            // given
            // when
            doReturn(Optional.empty()).when(userEntityRepository).findByPhoneNumber(any(String.class));

            // then
            softly.assertThatThrownBy(() -> authService.signIn(request))
                    .isInstanceOf(InvalidLoginException.class)
                    .hasMessage(ResultCode.INVALID_LOGIN.getMessage());
        }

        @Test
        @DisplayName("비밀번호가 일치하지 않으면 로그인에 실패한다.")
        void passwordInvalid(){
            // given
            // when
            doReturn(Optional.of(최규현)).when(userEntityRepository).findByPhoneNumber(any(String.class));

            // then
            softly.assertThatThrownBy(() -> authService.signIn(requestInvalidPassword))
                    .isInstanceOf(InvalidLoginException.class)
                    .hasMessage(ResultCode.INVALID_LOGIN.getMessage());
        }

        @Test
        @DisplayName("로그인 시에 사용자에게 fcm token이 추가된다.")
        void addFcmToken(){
            // given
            doReturn(Optional.of(최규현)).when(userEntityRepository).findByPhoneNumber(any(String.class));
            doReturn(true).when(passwordEncoder).matches(any(String.class), any(String.class));
            doReturn("jwtToken").when(jwtProvider).createToken(any(), any());

            // when
            authService.signIn(request);

            // then
            softly.assertThat(최규현.getFcmTokens().size()).isEqualTo(1);
        }
    }
}