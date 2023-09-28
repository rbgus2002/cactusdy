package ssu.groupstudy.domain.comment.dto.request;

import lombok.*;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.user.domain.User;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Getter
@AllArgsConstructor
@Builder
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class CreateCommentRequest {
    @NotNull
    private Long noticeId;
    @NotBlank
    private String contents;

    private Long parentCommentId;

    public Comment toEntity(User writer, Notice notice){
        return new Comment(contents, writer, notice);
    }
    public Comment toEntity(User writer, Notice notice, Comment parentComment){
        return new Comment(contents, writer, notice, parentComment);
    }
}
