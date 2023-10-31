package ssu.groupstudy.domain.notification.listener;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.notification.domain.event.AllUserTopicSubscribeEvent;
import ssu.groupstudy.domain.notification.domain.TopicCode;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.util.FcmUtils;

@Component
@Transactional
@RequiredArgsConstructor
@Slf4j
public class SubscribeListener {
    private final FcmUtils fcmUtils;

    @EventListener
    public void handleSignInSuccessEvent(AllUserTopicSubscribeEvent event) {
        User user = event.getUser();
        fcmUtils.subscribeTopicFor(user.getFcmTokenList(), TopicCode.ALL_USERS, null);
        log.info("## handleSignInSuccessEvent : ");
    }
}
