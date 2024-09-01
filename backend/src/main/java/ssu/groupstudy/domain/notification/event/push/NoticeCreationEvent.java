package ssu.groupstudy.domain.notification.event.push;

import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
@Builder
public class NoticeCreationEvent {
    private final Long studyId;
    private final Long noticeId;
    private final String noticeWriterNickname;
    private final String noticeTitle;
}
