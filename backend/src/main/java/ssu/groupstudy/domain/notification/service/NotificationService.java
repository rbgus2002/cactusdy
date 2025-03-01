package ssu.groupstudy.domain.notification.service;

import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.notification.param.NotificationParam;
import ssu.groupstudy.global.util.FcmUtils;

public abstract class NotificationService {
    @Autowired
    protected FcmUtils fcmUtils;

    public final void push(NotificationParam param) {
        pushNotification(param);
        saveNotificationHistory();
    }

    protected abstract void pushNotification(NotificationParam param);

    private void saveNotificationHistory() {
        // save notification history
        System.out.println("SAVE!!!!!!!!!!!!! TMP!!!!!!!!!!!!!");
    }
}
