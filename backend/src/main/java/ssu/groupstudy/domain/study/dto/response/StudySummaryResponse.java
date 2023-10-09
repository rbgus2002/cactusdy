package ssu.groupstudy.domain.study.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Study;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class StudySummaryResponse {
    private Long studyId;
    private String studyName;
    private String detail;
    private String picture;
    private String color;

    private StudySummaryResponse(Study study, Participant participant){
        this.studyId = study.getStudyId();
        this.studyName = study.getStudyName();
        this.detail = study.getDetail();
        this.picture = study.getPicture();
        this.color = participant.getColor();
    }

    public static StudySummaryResponse from(Study study, Participant participant){
        return new StudySummaryResponse(study, participant);
    }
}
