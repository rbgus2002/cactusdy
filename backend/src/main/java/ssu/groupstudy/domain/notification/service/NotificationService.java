package ssu.groupstudy.domain.notification.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.enums.TopicCode;
import ssu.groupstudy.domain.notification.param.NotificationParam;
import ssu.groupstudy.global.util.FcmUtils;

import javax.annotation.Nullable;
import java.util.List;

@Slf4j
public abstract class NotificationService {
    @Autowired
    protected FcmUtils fcmUtils;

    public final void push(NotificationParam param) {
        pushToFcm(param);
        saveNotificationHistory();
    }

    protected abstract void pushToFcm(NotificationParam param);

    public void subscribeToFcm(List<String> fcmTokens, TopicCode topicCode, @Nullable Long id){
        fcmUtils.subscribeTopicFor(fcmTokens, topicCode, id);
    }

    private void saveNotificationHistory() {
        // TODO() : save notification history
        log.debug("SAVE!!!!!!!!!!!!! TMP!!!!!!!!!!!!!");
    }
}
