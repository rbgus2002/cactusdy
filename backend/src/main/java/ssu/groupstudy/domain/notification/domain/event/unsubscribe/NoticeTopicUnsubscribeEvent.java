package ssu.groupstudy.domain.notification.domain.event.unsubscribe;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.util.List;

@Getter
@RequiredArgsConstructor
public class NoticeTopicUnsubscribeEvent {
    private final UserEntity user;
    private final List<Notice> notices;
}


