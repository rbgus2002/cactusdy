package ssu.groupstudy.domain.user.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.user.dto.response.UserInfoResponse;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertAll;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class UserServiceTest extends ServiceTest {
    @InjectMocks
    private UserService userService;

    @Mock
    private UserRepository userRepository;

    @Nested
    class 사용자조회{
        @Test
        @DisplayName("userId가 존재하지 않으면 예외를 던진다")
        void fail_invalidUserId() {
            // given
            doReturn(Optional.empty()).when(userRepository).findById(any(Long.class));

            // when, then
            assertThatThrownBy(() -> userService.getUser(-1L))
                    .isInstanceOf(UserNotFoundException.class)
                    .hasMessage(ResultCode.USER_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("성공")
        void success() {
            // given
            doReturn(Optional.of(최규현)).when(userRepository).findById(any(Long.class));

            // when
            final UserInfoResponse userInfoResponse = userService.getUser(1L);

            // then
            assertAll(
                    () -> assertThat(userInfoResponse).isNotNull(),
                    () -> assertThat(userInfoResponse.getUserId()).isEqualTo(1L),
                    () -> assertThat(userInfoResponse.getNickname()).isEqualTo("규규")

            );
        }
    }
}