package ssu.groupstudy.domain.notification.event.push;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.comment.entity.CommentEntity;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;

@Getter
@RequiredArgsConstructor
public class CommentCreationEvent {
    private final NoticeEntity notice;
    private final CommentEntity comment;

    public Long getStudyId() {
        return notice.getStudy().getStudyId();
    }

    public Long getNoticeId() {
        return notice.getNoticeId();
    }

    public String getCommentContents() {
        return comment.getContents();
    }

    public String getCommentWriterNickname() {
        return comment.getWriter().getNickname();
    }
}
