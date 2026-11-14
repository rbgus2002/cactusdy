package ssu.groupstudy.domain.study.param;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;
import ssu.groupstudy.global.util.ProfileImageUrlResolver;

import static org.assertj.core.api.Assertions.assertThat;

class ParticipantInfoTest {
    @AfterEach
    void tearDown() {
        ReflectionTestUtils.setField(ProfileImageUrlResolver.class, "baseUrl", null);
    }

    @Test
    @DisplayName("스터디 프로필 이미지는 저장된 key가 아닌 전체 URL로 반환한다")
    void studyProfileImageIsFullUrl() {
        ReflectionTestUtils.setField(ProfileImageUrlResolver.class, "baseUrl", "https://cactusdy.guegue.dev/images/");

        assertThat(new ParticipantInfo("스터디", "0xFF000000", "profile/study/90/a.webp").getStudyProfileImage())
                .isEqualTo("https://cactusdy.guegue.dev/images/profile/study/90/a.webp");
        assertThat(new ParticipantInfo("스터디", "0xFF000000", "https://old.host/a.webp").getStudyProfileImage())
                .isEqualTo("https://old.host/a.webp");
        assertThat(new ParticipantInfo("스터디", "0xFF000000", null).getStudyProfileImage()).isNull();
    }
}
