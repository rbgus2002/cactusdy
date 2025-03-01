package ssu.groupstudy.domain.notification.param;

import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
@Builder
public class NotificationCommentParam implements NotificationParam {
    private final Long noticeId;
    private final Long studyId;
    private final String commentWriterNickname;
    private final String commentContents;
}