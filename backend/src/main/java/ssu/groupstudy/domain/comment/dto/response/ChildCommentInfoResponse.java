package ssu.groupstudy.domain.comment.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.user.domain.User;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ChildCommentInfoResponse {
    private Long userId;
    private String nickname;
    private String picture;

    private Long commentId;
    private String contents;
    private LocalDateTime createDate;
    private char deleteYn;

    private ChildCommentInfoResponse(Comment comment) {
        User writer = comment.getWriter();
        this.userId = writer.getUserId();
        this.nickname = writer.getNickname();
        this.picture = writer.getPicture();

        this.commentId = comment.getCommentId();
        this.contents = comment.getContents();
        this.createDate = comment.getCreateDate();
        this.deleteYn = comment.getDeleteYn();
        processDeletedComment(comment);
    }

    private void processDeletedComment(Comment comment) {
        if(comment.isDeleted()){
            this.nickname = "(삭제)";
            this.contents = "삭제된 댓글입니다.";
            this.picture = "";
        }
    }

    public static ChildCommentInfoResponse from(Comment comment) {
        return new ChildCommentInfoResponse(comment);
    }
}
