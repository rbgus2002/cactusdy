package ssu.groupstudy.domain.notification.domain.event.subscribe;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.user.domain.User;

@Getter
@RequiredArgsConstructor
public class AllUserTopicSubscribeEvent {
    private final User user;
}
