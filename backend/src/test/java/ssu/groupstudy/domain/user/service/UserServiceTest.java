package ssu.groupstudy.domain.user.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.notification.service.FcmTokenService;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;

import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;
import static ssu.groupstudy.domain.common.constants.StringConstants.DASH;

class UserServiceTest extends ServiceTest {
    @InjectMocks
    private UserService userService;

    @Mock
    private FcmTokenService fcmTokenService;
    @Mock
    private UserEntityRepository userEntityRepository;

    @Nested
    class removeUser{
        @Test
        @DisplayName("회원 탈퇴 시 사용자의 닉네임, 상태메세지, 프로필 사진을 모두 삭제한다")
        void removeUser() {
            // given
            doReturn(Optional.of(최규현)).when(userEntityRepository).findById(any(Long.class));

            // when
            userService.removeUser(최규현.getUserId());

            // then
            softly.assertThat(최규현.isDeleted()).isTrue();
            softly.assertThat(최규현.getNickname()).isEqualTo(DASH);
            softly.assertThat(최규현.getStatusMessage()).isEqualTo(DASH);
            softly.assertThat(최규현.getPicture()).isNull();
        }
    }
}