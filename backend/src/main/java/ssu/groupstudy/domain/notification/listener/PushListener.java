package ssu.groupstudy.domain.notification.listener;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.common.enums.TopicCode;
import ssu.groupstudy.domain.notification.event.push.CommentCreationEvent;
import ssu.groupstudy.domain.notification.event.push.NoticeCreationEvent;
import ssu.groupstudy.domain.notification.event.push.TaskDoneEvent;
import ssu.groupstudy.domain.common.util.FcmUtils;

import java.util.Map;

import static ssu.groupstudy.domain.common.util.StringUtils.buildMessage;

@Component
@Transactional
@RequiredArgsConstructor
@Slf4j
public class PushListener {
    private final FcmUtils fcmUtils;

    @EventListener
    public void handleCommentCreationEvent(CommentCreationEvent event) {
        String title = buildMessage("댓글 | ", event.getCommentWriterNickname());
        String body = buildMessage("\"", event.getCommentContents(), "\"");

        Map<String, String> data = Map.of("type", "notice", "noticeId", event.getNoticeId().toString(), "studyId", event.getStudyId().toString());
        fcmUtils.sendNotificationToTopic(title, body, TopicCode.NOTICE, event.getNoticeId(), data);
    }

    @EventListener
    public void handleNoticeCreationEvent(NoticeCreationEvent event) {
        String title = buildMessage("공지사항 | ", event.getNoticeWriterNickname());
        String body = buildMessage("\"", event.getNoticeTitle(), "\"");

        Map<String, String> data = Map.of("type", "notice", "noticeId", event.getNoticeId().toString(), "studyId", event.getStudyId().toString());
        fcmUtils.sendNotificationToTopic(title, body, TopicCode.STUDY, event.getStudyId(), data);
    }

    @EventListener
    public void handleTaskDoneEvent(TaskDoneEvent event) {
        String title = buildMessage("과제 완료 | ", event.getNickname());
        String body = buildMessage("\"", event.getTaskDetail(), "\"");

        Map<String, String> data = Map.of("type", "round", "studyId", event.getStudyId().toString(), "roundId", event.getRoundId().toString(), "roundSeq", "-");
        fcmUtils.sendNotificationToTopic(title, body, TopicCode.STUDY, event.getStudyId(), data);
    }
}
