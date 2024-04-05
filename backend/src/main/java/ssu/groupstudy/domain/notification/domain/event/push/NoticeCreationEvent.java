package ssu.groupstudy.domain.notification.domain.event.push;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.study.domain.Study;

@Getter
@RequiredArgsConstructor
public class NoticeCreationEvent {
    private final Study study;
    private final Notice notice;

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
