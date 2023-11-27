package ssu.groupstudy.domain.study.domain;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class StudyTest {
    @Test
    @DisplayName("스터디를 init하면 초대 코드를 생성한다.")
    void generateInviteCode(){
        // given
        final String generatedInviteCode = "123456";
        Study study = Study.init("스터디", "스터디 설명", "0x00", null, generatedInviteCode);

        // when
        String inviteCode = study.getInviteCode();

        // then
        assertThat(inviteCode).isEqualTo(generatedInviteCode);
    }
}