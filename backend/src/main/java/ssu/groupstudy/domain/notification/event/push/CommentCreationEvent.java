package ssu.groupstudy.domain.notification.event.push;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.comment.entity.CommentEntity;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

@Getter
@RequiredArgsConstructor
public class CommentCreationEvent {
    private final UserEntity writer;
    private final NoticeEntity notice;
    private final StudyEntity study;
    private final CommentEntity comment;

    public Long getStudyId() {
        return study.getStudyId();
    }

    public Long getNoticeId() {
        return notice.getNoticeId();
    }

    public String getCommentContents() {
        return comment.getContents();
    }

    public String getCommentWriterNickname() {
        return writer.getNickname();
    }
}
