package ssu.groupstudy.domain.notification.domain.event.subscribe;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.user.entity.UserEntity;

@Getter
@RequiredArgsConstructor
public class NoticeTopicSubscribeEvent{
    private final UserEntity user;
    private final Notice notice;

    public Long getNoticeId(){
        return notice.getNoticeId();
    }
}
