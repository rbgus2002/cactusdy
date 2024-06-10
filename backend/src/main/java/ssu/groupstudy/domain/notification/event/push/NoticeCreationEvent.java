package ssu.groupstudy.domain.notification.event.push;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;

@Getter
@RequiredArgsConstructor
public class NoticeCreationEvent {
    private final StudyEntity study;
    private final NoticeEntity notice;

    public Long getStudyId(){
        return study.getStudyId();
    }

    public Long getNoticeId(){
        return notice.getNoticeId();
    }

    public String getStudyName(){
        return study.getStudyName();
    }

    public String getNoticeTitle(){
        return notice.getTitle();
    }

    public String getNoticeWriterNickname(){
        return notice.getWriter().getNickname();
    }
}
