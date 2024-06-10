package ssu.groupstudy.api.study.vo;

import lombok.Getter;
import lombok.ToString;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Getter
@ToString
public class EditStudyReqVo {
    @NotBlank(message = "이름을 입력하세요")
    private String studyName;
    @NotBlank(message = "설명을 입력하세요")
    private String detail;

    @NotBlank(message = "색상을 입력하세요")
    private String color;

    @NotNull(message = "방장을 입력하세요")
    private Long hostUserId;
}
