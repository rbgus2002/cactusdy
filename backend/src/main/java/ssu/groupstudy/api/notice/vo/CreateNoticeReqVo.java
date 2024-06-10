package ssu.groupstudy.api.notice.vo;

import lombok.*;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Getter
@AllArgsConstructor
@Builder
@ToString
public class CreateNoticeReqVo {
    @NotBlank
    private String title;
    @NotBlank
    private String contents;
    @NotNull
    private Long studyId;

    public NoticeEntity toEntity(UserEntity writer, StudyEntity study){
        return NoticeEntity.builder()
                .title(this.title)
                .contents(this.contents)
                .writer(writer)
                .study(study)
                .build();
    }
}
