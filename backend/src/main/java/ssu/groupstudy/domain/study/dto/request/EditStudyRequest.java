package ssu.groupstudy.domain.study.dto.request;

import lombok.Getter;
import lombok.ToString;
import ssu.groupstudy.domain.study.domain.Study;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Getter
@ToString
public class EditStudyRequest {
    @NotBlank(message = "이름을 입력하세요")
    private String studyName;
    @NotBlank(message = "설명을 입력하세요")
    private String detail;

    @NotBlank(message = "색상을 입력하세요")
    private String color;

    @NotNull(message = "방장을 입력하세요")
    private Long hostUserId;

    public Study toEntity() {
        return Study.create(studyName, detail);
    }
}
