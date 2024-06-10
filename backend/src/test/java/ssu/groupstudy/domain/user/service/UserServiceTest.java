package ssu.groupstudy.domain.user.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;
import ssu.groupstudy.global.util.S3Utils;

class UserServiceTest extends ServiceTest {
    @InjectMocks
    private UserService userService;
    @Mock
    private UserEntityRepository userEntityRepository;
    @Mock
    private S3Utils s3Utils;

    @Nested
    class DeleteUser{
        @Test
        @DisplayName("회원 탈퇴 시 사용자의 닉네임, 상태메세지, 프로필 사진을 모두 삭제한다")
        void deleteUserInfo(){
            // given
            // when
            userService.removeUser(최규현);

            // then
            softly.assertThat(최규현.isDeleted()).isEqualTo('Y');
            softly.assertThat(최규현.getNickname()).isEqualTo("-");
            softly.assertThat(최규현.getStatusMessage()).isEqualTo("-");
            softly.assertThat(최규현.getPicture()).isNull();
        }

        @Test
        @DisplayName("회원 탈퇴 시 가지는 FCM 토큰을 모두 삭제한다")
        void deleteAllFcmTokens(){
            // given
            최규현.addFcmToken("token1");
            최규현.addFcmToken("token2");
            최규현.addFcmToken("token3");

            // when
            userService.removeUser(최규현);

            // then
            softly.assertThat(최규현.getFcmTokens().size()).isEqualTo(0);
        }
    }
}