package ssu.groupstudy.domain.notification.event.subscribe;

import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.List;

@Getter
@RequiredArgsConstructor
@Builder
public class NoticeTopicSubscribeEvent{
    private final List<String> fcmTokens;
    private final Long noticeId;
}
