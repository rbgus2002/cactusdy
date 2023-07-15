package ssu.groupstudy.domain.comment.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.user.domain.User;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ReplyCommentInfoResponse {
    private Long userId;
    private String nickname;
    private String picture;

    private Long commentId;
    private String contents;
    private LocalDateTime createDate;

    private ReplyCommentInfoResponse(Comment comment) {
        User writer = comment.getWriter();
        this.userId = writer.getUserId();
        this.nickname = writer.getNickname();
        this.picture = writer.getPicture();

        this.commentId = comment.getCommentId();
        this.contents = comment.getContents();
        this.createDate = comment.getCreateDate();
    }

    public static ReplyCommentInfoResponse from(Comment comment) {
        return new ReplyCommentInfoResponse(comment);
    }
}
