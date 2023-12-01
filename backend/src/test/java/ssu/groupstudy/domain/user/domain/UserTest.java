package ssu.groupstudy.domain.user.domain;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.assertj.core.api.junit.jupiter.SoftAssertionsExtension;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

@ExtendWith(SoftAssertionsExtension.class)
class UserTest {
    @InjectSoftAssertions
    private SoftAssertions softly;

    @Test
    @DisplayName("사용자 권한을 추가하면 USER_ROLE을 획득한다.")
    void addUserRole(){
        // given
        User user = User.builder()
                .name("")
                .nickname("")
                .phoneNumber("")
                .build();

        // when
        user.addUserRole();

        // then
        softly.assertThat(user.getRoles().size()).isEqualTo(1);
        softly.assertThat(user.getRoles().get(0).getName()).isEqualTo("ROLE_USER");
    }

    @Test
    @DisplayName("사용자의 FCM 토큰을 삭제한다.")
    void UserTest(){
        // given
        User user = User.builder()
                .name("")
                .nickname("")
                .phoneNumber("")
                .build();

        // when
        user.addFcmToken("valid");
        user.deleteFcmToken("valid");

        // then
        softly.assertThat(user.getFcmTokenList().size()).isEqualTo(0);
    }
}