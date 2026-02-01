package ssu.groupstudy.domain.notification.param;

import ssu.groupstudy.domain.common.enums.NotificationDataType;
import ssu.groupstudy.domain.common.enums.TopicCode;

import java.util.Map;

public interface NotificationParam {
    String getTitle();

    String getBody();

    Map<String, String> getData();

    TopicCode getTopicCode();

    Long getTopicId();

    NotificationDataType getNotificationDataType();

    Long getStudyId();
}
