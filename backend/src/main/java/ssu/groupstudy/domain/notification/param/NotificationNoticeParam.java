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
public class NotificationNoticeParam implements NotificationParam {
    private final Long studyId;
    private final Long noticeId;
    private final String noticeWriterNickname;
    private final String noticeTitle;

    @Override
    public String getTitle() {
        return buildMessage(NOTICE, noticeWriterNickname);
    }

    @Override
    public String getBody() {
        return buildMessage(DOUBLE_QUOTE, noticeTitle, DOUBLE_QUOTE);
    }

    @Override
    public Map<String, String> getData() {
        return Map.of(
                DATA_TYPE, NotificationDataType.NOTICE.getValue(),
                NOTICE_ID, noticeId.toString(),
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
        return NotificationDataType.NOTICE;
    }

    @Override
    public Long getStudyId() {
        return studyId;
    }
}
