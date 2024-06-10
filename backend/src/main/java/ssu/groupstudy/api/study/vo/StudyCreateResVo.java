package ssu.groupstudy.api.study.vo;

import lombok.Getter;

@Getter
public class StudyCreateResVo {
    private final Long studyId;
    private final String inviteCode;

    private StudyCreateResVo(Long studyId, String inviteCode) {
        this.studyId = studyId;
        this.inviteCode = inviteCode;
    }

    public static StudyCreateResVo of(Long studyId, String inviteCode) {
        return new StudyCreateResVo(studyId, inviteCode);
    }
}
