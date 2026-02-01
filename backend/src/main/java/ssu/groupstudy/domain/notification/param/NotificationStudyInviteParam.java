package ssu.groupstudy.domain.notification.param;

import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.common.enums.NotificationDataType;
import ssu.groupstudy.domain.common.enums.TopicCode;

import java.util.Map;

import static ssu.groupstudy.domain.common.constants.NotificationConstants.*;
import static ssu.groupstudy.global.util.StringUtils.buildMessage;

@Getter
@RequiredArgsConstructor
@Builder
public class NotificationStudyInviteParam implements NotificationParam {
    private final Long studyId;
    private final String studyName;
    private final String userName;

    @Override
    public String getTitle() {
        return buildMessage(STUDY_INVITE, userName);
    }

    @Override
    public String getBody() {
        return buildMessage(userName, "님이 ", studyName, " 스터디에 초대됐어요.");
    }

    @Override
    public Map<String, String> getData() {
        return Map.of(
                DATA_TYPE, NotificationDataType.STUDY.getValue(),
                STUDY_ID, studyId.toString()
        );
    }

    @Override
    public TopicCode getTopicCode() {
        return TopicCode.STUDY;
    }

    @Override
    public Long getTopicId() {
        return studyId;
    }

    @Override
    public NotificationDataType getNotificationDataType() {
        return NotificationDataType.STUDY;
    }

    @Override
    public Long getStudyId() {
        return studyId;
    }
}
