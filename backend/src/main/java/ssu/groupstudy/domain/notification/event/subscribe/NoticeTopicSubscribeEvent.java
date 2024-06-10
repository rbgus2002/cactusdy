package ssu.groupstudy.domain.notification.event.subscribe;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

@Getter
@RequiredArgsConstructor
public class NoticeTopicSubscribeEvent{
    private final UserEntity user;
    private final NoticeEntity notice;

    public Long getNoticeId(){
        return notice.getNoticeId();
    }
}
