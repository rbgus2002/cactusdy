package ssu.groupstudy.domain.study.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.domain.Study;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class StudySummaryResponse {
    private Long studyId;
    private String studyName;
    private String detail;
    private String picture;

    private StudySummaryResponse(Study study){
        this.studyId = study.getStudyId();
        this.studyName = study.getStudyName();
        this.detail = study.getDetail();
        this.picture = study.getPicture();
    }

    public static StudySummaryResponse from(Study study){
        return new StudySummaryResponse(study);
    }
}
