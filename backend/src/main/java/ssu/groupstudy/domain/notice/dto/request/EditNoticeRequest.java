package ssu.groupstudy.domain.notice.dto.request;

import lombok.Getter;
import lombok.ToString;

import javax.validation.constraints.NotBlank;

@Getter
@ToString
public class EditNoticeRequest {
    @NotBlank
    private String title;
    @NotBlank
    private String contents;
}
