package ssu.groupstudy.domain.comment.dto.request;

import lombok.*;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.user.entity.UserEntity;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Getter
@AllArgsConstructor
@Builder
@NoArgsConstructor(access = AccessLevel.PRIVATE)
@ToString
public class CreateCommentRequest {
    @NotNull
    private Long noticeId;
    @NotBlank
    private String contents;

    private Long parentCommentId;

    public Comment toEntity(UserEntity writer, Notice notice, Comment parentComment){
        return new Comment(contents, writer, notice, parentComment);
    }
}
