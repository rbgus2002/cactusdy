package ssu.groupstudy.domain.auth.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.springframework.security.crypto.password.PasswordEncoder;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.exception.PhoneNumberExistsException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.util.MessageUtils;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class AuthServiceTest extends ServiceTest {
    @InjectMocks
    private AuthService authService;
    @Mock
    private UserRepository userRepository;
    @Mock
    private MessageUtils messageUtils;
    @Spy
    private PasswordEncoder passwordEncoder;

    @Nested
    class 회원가입 {
        @Test
        @DisplayName("중복되는 핸드폰번호가 존재하면 예외를 던진다")
        void fail_emailDuplicated() {
            // given
            doReturn(true).when(userRepository).existsByPhoneNumber(any(String.class));

            // when, then
            softly.assertThatThrownBy(() -> authService.signUp(최규현SignUpRequest))
                    .isInstanceOf(PhoneNumberExistsException.class)
                    .hasMessage(ResultCode.DUPLICATE_PHONE_NUMBER.getMessage());
        }

        @Test
        @DisplayName("회원가입 성공")
        void success() {
            // given
            doReturn(false).when(userRepository).existsByPhoneNumber(any(String.class));
            doReturn(최규현).when(userRepository).save(any(User.class));

            // when
            final Long userId = authService.signUp(최규현SignUpRequest);

            // then
            softly.assertThat(userId).isNotNull();
        }
    }
}