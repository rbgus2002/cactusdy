package ssu.groupstudy.domain.user.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.notification.service.FcmTokenService;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.util.ImageManager;

import java.io.IOException;
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
    private UserRepository userRepository;
    @Mock
    private ImageManager imageManager;

    @Nested
    class RemoveUser{
        @Test
        @DisplayName("회원 탈퇴 시 사용자의 닉네임, 상태메세지, 프로필 사진을 모두 삭제한다")
        void removeUser() {
            // given
            doReturn(Optional.of(최규현)).when(userRepository).findById(any(Long.class));

            // when
            userService.removeUser(최규현.getUserId());

            // then
            softly.assertThat(최규현.isDeleted()).isTrue();
            softly.assertThat(최규현.getNickname()).isEqualTo(DASH);
            softly.assertThat(최규현.getStatusMessage()).isEqualTo(DASH);
            softly.assertThat(최규현.getPicture()).isNull();
        }
    }

    @Nested
    class EditUser{
        @Test
        @DisplayName("회원 정보 수정 시 사용자의 닉네임, 상태메세지, 프로필 사진을 수정한다")
        void editUser() throws IOException {
            // given
            doReturn(Optional.of(최규현)).when(userRepository).findById(any(Long.class));

            // when
            userService.editUser(최규현.getUserId(), "최규현", "하이", null);

            // then
            softly.assertThat(최규현.getNickname()).isEqualTo("최규현");
            softly.assertThat(최규현.getStatusMessage()).isEqualTo("하이");
            softly.assertThat(최규현.getPicture()).isNull();
        }
    }
}