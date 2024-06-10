package ssu.groupstudy.api.notice.vo;

import lombok.Getter;
import lombok.ToString;

import javax.validation.constraints.NotBlank;

@Getter
@ToString
public class EditNoticeReqVo {
    @NotBlank
    private String title;
    @NotBlank
    private String contents;
}
