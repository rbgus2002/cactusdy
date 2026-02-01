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
public class NotificationTaskDoneParam implements NotificationParam {
    private final String nickname;
    private final String taskDetail;
    private final Long studyId;
    private final Long roundId;
    private final Long taskId;

    @Override
    public String getTitle() {
        return buildMessage(TASK_DONE, nickname);
    }

    @Override
    public String getBody() {
        return buildMessage(DOUBLE_QUOTE, taskDetail, DOUBLE_QUOTE);
    }

    @Override
    public Map<String, String> getData() {
        return Map.of(
                DATA_TYPE, NotificationDataType.ROUND.getValue(),
                STUDY_ID, studyId.toString(),
                ROUND_ID, roundId.toString(),
                TASK_ID, taskId.toString()
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
        return NotificationDataType.ROUND;
    }

    @Override
    public Long getStudyId() {
        return studyId;
    }
}
