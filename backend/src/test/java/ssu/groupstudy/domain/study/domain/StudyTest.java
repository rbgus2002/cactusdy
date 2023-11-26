package ssu.groupstudy.domain.study.domain;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class StudyTest {
    @Test
    @DisplayName("스터디를 init하면 초대 코드를 생성한다.")
    void generateInviteCode(){
        // given
        Study study = Study.init("스터디", "스터디 설명", "0x00", null);

        // when
        String inviteCode = study.getInviteCode();

        // then
        System.out.println(inviteCode);
    }
}