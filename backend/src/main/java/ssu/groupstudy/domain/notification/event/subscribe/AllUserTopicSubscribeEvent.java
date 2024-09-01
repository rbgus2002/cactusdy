package ssu.groupstudy.domain.notification.event.subscribe;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.List;

@Getter
@RequiredArgsConstructor
public class AllUserTopicSubscribeEvent {
    private final List<String> fcmTokens;
}
