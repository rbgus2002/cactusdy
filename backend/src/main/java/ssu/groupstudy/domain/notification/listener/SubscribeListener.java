package ssu.groupstudy.domain.notification.listener;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notification.domain.event.subscribe.AllUserTopicSubscribeEvent;
import ssu.groupstudy.domain.notification.domain.TopicCode;
import ssu.groupstudy.domain.notification.domain.event.subscribe.NoticeTopicSubscribeEvent;
import ssu.groupstudy.domain.notification.domain.event.subscribe.StudyTopicSubscribeEvent;
import ssu.groupstudy.domain.notification.domain.event.unsubscribe.NoticeTopicUnsubscribeEvent;
import ssu.groupstudy.domain.notification.domain.event.unsubscribe.StudyTopicUnsubscribeEvent;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.util.FcmUtils;

@Component
@Transactional
@RequiredArgsConstructor
@Slf4j
public class SubscribeListener {
    private final FcmUtils fcmUtils;

    @EventListener
    public void handleAllUserTopicSubscribeEvent(AllUserTopicSubscribeEvent event) {
        User user = event.getUser();
        fcmUtils.subscribeTopicFor(user.getFcmTokenList(), TopicCode.ALL_USERS, null);
        log.info("## handleAllUserTopicSubscribeEvent : ");
    }

    @EventListener
    public void handleNoticeTopicSubscribeEvent(NoticeTopicSubscribeEvent event) {
        User user = event.getUser();
        fcmUtils.subscribeTopicFor(user.getFcmTokenList(), TopicCode.NOTICE, event.getNoticeId());
        log.info("## handleNoticeTopicSubscribeEvent : ");
    }

    @EventListener
    public void handleStudyTopicSubscribeEvent(StudyTopicSubscribeEvent event) {
        User user = event.getUser();
        fcmUtils.subscribeTopicFor(user.getFcmTokenList(), TopicCode.STUDY, event.getStudyId());
        log.info("## handleStudyTopicSubscribeEvent : ");
    }

    @EventListener
    public void handleStudyTopicUnSubscribeEvent(StudyTopicUnsubscribeEvent event) {
        User user = event.getUser();
        fcmUtils.unsubscribeTopicFor(user.getFcmTokenList(), TopicCode.STUDY, event.getStudyId());
        log.info("## handleStudyTopicUnSubscribeEvent : ");
    }

    @EventListener
    public void handleNoticeTopicUnSubscribeEvent(NoticeTopicUnsubscribeEvent event) {
        User user = event.getUser();
        for (Notice notice : event.getNotices()) {
            fcmUtils.unsubscribeTopicFor(user.getFcmTokenList(), TopicCode.NOTICE, notice.getNoticeId());
        }
        log.info("## handleNoticeTopicUnSubscribeEvent : ");
    }

}
