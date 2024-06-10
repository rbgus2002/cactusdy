package ssu.groupstudy.domain.notification.event.subscribe;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.user.entity.UserEntity;

@Getter
@RequiredArgsConstructor
public class AllUserTopicSubscribeEvent {
    private final UserEntity user;
}
