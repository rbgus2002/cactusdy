package ssu.groupstudy.domain.notification.listener;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.notification.domain.TopicCode;
import ssu.groupstudy.domain.notification.domain.event.push.CommentCreationEvent;
import ssu.groupstudy.domain.notification.domain.event.push.NoticeCreationEvent;
import ssu.groupstudy.domain.notification.domain.event.push.TaskDoneEvent;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.util.FcmUtils;

@Component
@Transactional
@RequiredArgsConstructor
@Slf4j
public class PushListener {
    private final FcmUtils fcmUtils;

    @EventListener
    public void handleCommentCreationEvent(CommentCreationEvent event) {
        User user = event.getUser();
        String body = String.format("[%s]님이 댓글을 작성했습니다.", user.getNickname());
        fcmUtils.sendNotificationToTopic("공지사항", body, TopicCode.NOTICE, event.getNoticeId());
    }

    @EventListener
    public void handleNoticeCreationEvent(NoticeCreationEvent event) {
        User user = event.getUser();
        String body = String.format("[%s]님이 공지사항을 작성했습니다.", user.getNickname());
        fcmUtils.sendNotificationToTopic("스터디", body, TopicCode.STUDY, event.getStudyId());
    }

    @EventListener
    public void handleTaskDoneEvent(TaskDoneEvent event) {
        User user = event.getUser();
        String body = String.format("[%s]님이 과제를 완료했습니다.", user.getNickname());
        fcmUtils.sendNotificationToTopic("스터디", body, TopicCode.STUDY, event.getStudyId());
    }
}
