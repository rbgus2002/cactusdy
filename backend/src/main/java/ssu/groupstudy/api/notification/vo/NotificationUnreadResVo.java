package ssu.groupstudy.api.notification.vo;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class NotificationUnreadResVo {
    private boolean hasUnread;

    public static NotificationUnreadResVo from(boolean hasUnread) {
        return new NotificationUnreadResVo(hasUnread);
    }
}
