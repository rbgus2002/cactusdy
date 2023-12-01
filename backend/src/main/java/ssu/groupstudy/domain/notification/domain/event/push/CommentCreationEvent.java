package ssu.groupstudy.domain.notification.domain.event.push;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.notice.domain.Notice;

@Getter
@RequiredArgsConstructor
public class CommentCreationEvent {
    private final Notice notice;
    private final Comment comment;

    public Long getNoticeId(){
        return notice.getNoticeId();
    }
    public String getStudyName(){
        return notice.getStudy().getStudyName();
    }
    public String getCommentContents(){
        return comment.getContents();
    }
}
