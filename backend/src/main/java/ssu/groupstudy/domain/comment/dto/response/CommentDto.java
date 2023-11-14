package ssu.groupstudy.domain.comment.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.user.domain.User;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class CommentDto {
    private Long userId;
    private String nickname;
    private String picture;

    private Long commentId;
    private String contents;
    private LocalDateTime createDate;
    private char deleteYn;

    private List<ChildCommentInfoResponse> replies = null;

    private CommentDto(Comment comment) {
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

    public static CommentDto from(Comment comment) {
        return new CommentDto(comment);
    }

    public void appendReplies(List<ChildCommentInfoResponse> replies){
        this.replies = replies;
    }

    public boolean requireRemoved(){
        return this.isDeleted() && !this.existReplies();
    }

    private boolean isDeleted(){
        return this.deleteYn == 'Y';
    }

    private boolean existReplies(){
        return this.replies != null && !isReplyEmpty();
    }

    private boolean isReplyEmpty(){
        return replies.stream()
                .noneMatch(reply -> reply.getDeleteYn() == 'N');
    }
}