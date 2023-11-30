package ssu.groupstudy.domain.notice.dto.request;

import lombok.*;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.user.domain.User;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Getter
@AllArgsConstructor
@Builder
@ToString
public class CreateNoticeRequest {
    @NotBlank
    private String title;
    @NotBlank
    private String contents;
    @NotNull
    private Long studyId;

    public Notice toEntity(User writer, Study study){
        return Notice.builder()
                .title(this.title)
                .contents(this.contents)
                .writer(writer)
                .study(study)
                .build();
    }
}
