package ssu.groupstudy.domain.notification.listener;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.common.enums.TopicCode;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.domain.notification.event.subscribe.AllUserTopicSubscribeEvent;
import ssu.groupstudy.domain.notification.event.subscribe.NoticeTopicSubscribeEvent;
import ssu.groupstudy.domain.notification.event.subscribe.StudyTopicSubscribeEvent;
import ssu.groupstudy.domain.notification.event.unsubscribe.NoticeTopicUnsubscribeEvent;
import ssu.groupstudy.domain.notification.event.unsubscribe.StudyTopicUnsubscribeEvent;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.global.util.FcmUtils;

@Component
@Transactional
@RequiredArgsConstructor
@Slf4j
public class SubscribeListener {
    private final FcmUtils fcmUtils;

    @EventListener
    @Async
    public void handleAllUserTopicSubscribeEvent(AllUserTopicSubscribeEvent event) {
        log.info("## handleAllUserTopicSubscribeEvent : ");
        fcmUtils.subscribeTopicFor(event.getFcmTokens(), TopicCode.ALL_USERS, null);
    }

    @EventListener
    @Async
    public void handleNoticeTopicSubscribeEvent(NoticeTopicSubscribeEvent event) {
        log.info("## handleNoticeTopicSubscribeEvent : ");
        fcmUtils.subscribeTopicFor(event.getFcmTokens(), TopicCode.NOTICE, event.getNoticeId());
    }

    @EventListener
    @Async
    public void handleStudyTopicSubscribeEvent(StudyTopicSubscribeEvent event) {
        log.info("## handleStudyTopicSubscribeEvent : ");
        fcmUtils.subscribeTopicFor(event.getFcmTokens(), TopicCode.STUDY, event.getStudyId());
    }

    @EventListener
    @Async
    public void handleStudyTopicUnSubscribeEvent(StudyTopicUnsubscribeEvent event) {
        log.info("## handleStudyTopicUnSubscribeEvent : ");
        fcmUtils.unsubscribeTopicFor(event.getFcmTokens(), TopicCode.STUDY, event.getStudyId());
    }

    @EventListener
    @Async
    public void handleNoticeTopicUnSubscribeEvent(NoticeTopicUnsubscribeEvent event) {
        log.info("## handleNoticeTopicUnSubscribeEvent : ");
        UserEntity user = event.getUser();
        for (NoticeEntity notice : event.getNotices()) {
            fcmUtils.unsubscribeTopicFor(user.getFcmTokens(), TopicCode.NOTICE, notice.getNoticeId());
        }
    }

}
