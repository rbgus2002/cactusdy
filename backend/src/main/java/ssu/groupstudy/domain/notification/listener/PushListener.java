package ssu.groupstudy.domain.notification.listener;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.common.enums.NotificationDataType;
import ssu.groupstudy.domain.common.enums.TopicCode;
import ssu.groupstudy.domain.notification.event.push.CommentCreationEvent;
import ssu.groupstudy.domain.notification.event.push.NoticeCreationEvent;
import ssu.groupstudy.domain.notification.event.push.TaskDoneEvent;
import ssu.groupstudy.global.util.FcmUtils;

import java.util.Map;

import static ssu.groupstudy.domain.common.constants.NotificationConstants.*;
import static ssu.groupstudy.global.util.StringUtils.buildMessage;

@Component
@Transactional
@RequiredArgsConstructor
@Slf4j
public class PushListener {
    private final FcmUtils fcmUtils;

    @EventListener
    @Async
    public void handleCommentCreationEvent(CommentCreationEvent event) {
        String title = buildMessage(COMMENT, event.getCommentWriterNickname());
        String body = buildMessage(DOUBLE_QUOTE, event.getCommentContents(), DOUBLE_QUOTE);

        Map<String, String> data = Map.of(DATA_TYPE, NotificationDataType.NOTICE.getValue(), NOTICE_ID, event.getNoticeId().toString(), STUDY_ID, event.getStudyId().toString());
        fcmUtils.sendNotificationToTopic(title, body, TopicCode.NOTICE, event.getNoticeId(), data);
    }

    @EventListener
    @Async
    public void handleNoticeCreationEvent(NoticeCreationEvent event) {
        String title = buildMessage(NOTICE, event.getNoticeWriterNickname());
        String body = buildMessage(DOUBLE_QUOTE, event.getNoticeTitle(), DOUBLE_QUOTE);

        Map<String, String> data = Map.of(DATA_TYPE, NotificationDataType.NOTICE.getValue(), NOTICE_ID, event.getNoticeId().toString(), STUDY_ID, event.getStudyId().toString());
        fcmUtils.sendNotificationToTopic(title, body, TopicCode.STUDY, event.getStudyId(), data);
    }

    @EventListener
    @Async
    public void handleTaskDoneEvent(TaskDoneEvent event) {
        String title = buildMessage(TASK_DONE, event.getNickname());
        String body = buildMessage(DOUBLE_QUOTE, event.getTaskDetail(), DOUBLE_QUOTE);

        Map<String, String> data = Map.of(DATA_TYPE, NotificationDataType.ROUND.getValue(), STUDY_ID, event.getStudyId().toString(), ROUND_ID, event.getRoundId().toString(), ROUND_SEQ, HYPHEN);
        fcmUtils.sendNotificationToTopic(title, body, TopicCode.STUDY, event.getStudyId(), data);
    }
}
