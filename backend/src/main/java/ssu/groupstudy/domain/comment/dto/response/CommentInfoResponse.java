package ssu.groupstudy.domain.comment.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.user.domain.User;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class CommentInfoResponse {
    private Long userId;
    private String nickname;
    private String picture;

    private Long commentId;
    private String contents;
    private LocalDateTime createDate;

    private CommentInfoResponse(Comment comment) {
        User writer = comment.getWriter();
        this.userId = writer.getUserId();
        this.nickname = writer.getNickname();
        this.picture = writer.getPicture();

        this.commentId = comment.getCommentId();
        this.contents = comment.getContents();
        this.createDate = comment.getCreateDate();
    }

    public static CommentInfoResponse from(Comment comment) {
        return new CommentInfoResponse(comment);
    }
}
