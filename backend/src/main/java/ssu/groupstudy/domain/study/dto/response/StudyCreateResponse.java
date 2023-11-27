package ssu.groupstudy.domain.study.dto.response;

import lombok.Getter;

@Getter
public class StudyCreateResponse {
    private final Long studyId;
    private final String inviteCode;

    private StudyCreateResponse(Long studyId, String inviteCode) {
        this.studyId = studyId;
        this.inviteCode = inviteCode;
    }

    public static StudyCreateResponse of(Long studyId, String inviteCode) {
        return new StudyCreateResponse(studyId, inviteCode);
    }
}
