package ssu.groupstudy.api.comment.vo;

import lombok.*;
import ssu.groupstudy.domain.comment.entity.CommentEntity;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

import javax.annotation.Nullable;
import javax.validation.constraints.NotBlank;

@Getter
@Builder
@ToString
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class CreateCommentV2ReqVo {
    @NotBlank
    private String contents;
    private Long parentCommentId;

    public CommentEntity toEntity(UserEntity writer, NoticeEntity notice, @Nullable CommentEntity parentComment) {
        return CommentEntity.builder()
                .contents(this.contents)
                .writer(writer)
                .notice(notice)
                .parentComment(parentComment)
                .build();
    }
}
