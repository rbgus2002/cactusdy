package ssu.groupstudy.domain.login.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.exception.EmailExistsException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.domain.user.service.UserService;
import ssu.groupstudy.global.ResultCode;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class LoginServiceTest extends ServiceTest {
    @InjectMocks
    private UserService loginService;

    @Mock
    private UserRepository userRepository;

    @Nested
    class 회원가입{
        @Test
        @DisplayName("중복되는 이메일이 존재하면 회원가입이 불가능하다")
        void fail_emailDuplicated() {
            // given
            doReturn(true).when(userRepository).existsByEmail(any(String.class));

            // when, then
            assertThatThrownBy(() -> loginService.signUp(최규현SignUpRequest))
                    .isInstanceOf(EmailExistsException.class)
                    .hasMessage(ResultCode.DUPLICATE_EMAIL.getMessage());
        }

        @Test
        @DisplayName("회원가입 성공")
        void success() {
            // given
            doReturn(false).when(userRepository).existsByEmail(any(String.class));
            doReturn(최규현).when(userRepository).save(any(User.class));

            // when
            final Long userId = loginService.signUp(최규현SignUpRequest);

            // then
            assertThat(userId).isNotNull();
        }
    }
}