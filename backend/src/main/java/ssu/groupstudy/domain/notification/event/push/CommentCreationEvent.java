package ssu.groupstudy.domain.notification.event.push;

import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
@Builder
public class CommentCreationEvent {
    private final Long noticeId;
    private final Long studyId;
    private final String commentWriterNickname;
    private final String commentContents;
}
