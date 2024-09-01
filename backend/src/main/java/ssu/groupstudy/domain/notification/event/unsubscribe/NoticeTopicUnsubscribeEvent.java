package ssu.groupstudy.domain.notification.event.unsubscribe;

import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.List;

@Getter
@RequiredArgsConstructor
@Builder
public class NoticeTopicUnsubscribeEvent {
    private final List<String> fcmTokens;
    private final List<Long> noticeIds;
}


