package ssu.groupstudy.api.comment.vo;

import lombok.*;
import ssu.groupstudy.domain.comment.entity.CommentEntity;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Getter
@AllArgsConstructor
@Builder
@NoArgsConstructor(access = AccessLevel.PRIVATE)
@ToString
public class CreateCommentReqVo {
    @NotNull
    private Long noticeId;
    @NotBlank
    private String contents;

    private Long parentCommentId;

    public CommentEntity toEntity(UserEntity writer, NoticeEntity notice, CommentEntity parentComment){
        return new CommentEntity(contents, writer, notice, parentComment);
    }
}
