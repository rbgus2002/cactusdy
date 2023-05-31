package ssu.groupstudy.domain.user.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.response.UserInfoResponse;
import ssu.groupstudy.domain.user.exception.EmailExistsException;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class UserServiceTest extends ServiceTest {
    @InjectMocks
    private UserService userService;

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
            assertThatThrownBy(() -> userService.signUp(최규현SignUpRequest))
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
            final User newUser = userService.signUp(최규현SignUpRequest);

            // then
            assertAll(
                    () -> assertThat(newUser).isNotNull(),
                    () -> assertThat(newUser.getName()).isEqualTo("최규현"),
                    () -> assertThat(newUser.getEmail()).isEqualTo("rbgus200@naver.com")
            );
        }
    }

    @Nested
    class 사용자조회{
        @Test
        @DisplayName("userId가 존재하지 않으면 예외를 던진다")
        void fail_invalidUserId() {
            // given
            doReturn(Optional.empty()).when(userRepository).findByUserId(any(Long.class));

            // when, then
            assertThatThrownBy(() -> userService.findUser(-1L))
                    .isInstanceOf(UserNotFoundException.class)
                    .hasMessage(ResultCode.USER_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("성공")
        void success() {
            // given
            doReturn(Optional.of(최규현)).when(userRepository).findByUserId(any(Long.class));

            // when
            final UserInfoResponse userInfoResponse = userService.findUser(1L);

            // then
            assertAll(
                    () -> assertThat(userInfoResponse).isNotNull(),
                    () -> assertThat(userInfoResponse.getUserId()).isEqualTo(1L),
                    () -> assertThat(userInfoResponse.getNickName()).isEqualTo("규규")

            );
        }
    }
}