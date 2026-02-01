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
import ssu.groupstudy.domain.notification.service.NotificationHistoryService;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.study.repository.ParticipantEntityRepository;
import ssu.groupstudy.global.util.FcmUtils;

import java.util.List;
import java.util.Map;

import static ssu.groupstudy.domain.common.constants.NotificationConstants.*;
import static ssu.groupstudy.global.util.StringUtils.buildMessage;

@Component
@Transactional
@RequiredArgsConstructor
@Slf4j
public class PushListener {
    private final FcmUtils fcmUtils;
    private final NotificationHistoryService notificationHistoryService;
    private final ParticipantEntityRepository participantEntityRepository;

    @EventListener
    @Async
    public void handleCommentCreationEvent(CommentCreationEvent event) {
        String title = buildMessage(COMMENT, event.getCommentWriterNickname());
        String body = buildMessage(DOUBLE_QUOTE, event.getCommentContents(), DOUBLE_QUOTE);

        Map<String, String> data = Map.of(
                DATA_TYPE, NotificationDataType.NOTICE.getValue(),
                NOTICE_ID, event.getNoticeId().toString(),
                STUDY_ID, event.getStudyId().toString()
        );
        fcmUtils.sendNotificationToTopic(title, body, TopicCode.NOTICE, event.getNoticeId(), data);
        
        // 알림 히스토리 저장 - 공지사항 주제를 구독한 사용자들에게 저장
        // 현재는 스터디 참가자 모두에게 저장 (추후 실제 구독자 필터링 필요)
        List<ParticipantEntity> participants = participantEntityRepository.findAllActiveByStudyId(event.getStudyId());
                
        participants.forEach(participant ->
            notificationHistoryService.saveNotificationHistory(
                participant.getUser(), 
                NotificationDataType.NOTICE,
                title, 
                body, 
                data
            )
        );
    }

    @EventListener
    @Async
    public void handleNoticeCreationEvent(NoticeCreationEvent event) {
        String title = buildMessage(NOTICE, event.getNoticeWriterNickname());
        String body = buildMessage(DOUBLE_QUOTE, event.getNoticeTitle(), DOUBLE_QUOTE);

        Map<String, String> data = Map.of(
                DATA_TYPE, NotificationDataType.NOTICE.getValue(),
                NOTICE_ID, event.getNoticeId().toString(),
                STUDY_ID, event.getStudyId().toString()
        );
        fcmUtils.sendNotificationToTopic(title, body, TopicCode.STUDY, event.getStudyId(), data);
        
        // 알림 히스토리 저장 - 스터디 주제를 구독한 사용자들에게 저장
        List<ParticipantEntity> participants = participantEntityRepository.findAllActiveByStudyId(event.getStudyId());
                
        participants.forEach(participant ->
            notificationHistoryService.saveNotificationHistory(
                participant.getUser(), 
                NotificationDataType.NOTICE,
                title, 
                body,
                data
            )
        );
    }

    @EventListener
    @Async
    public void handleTaskDoneEvent(TaskDoneEvent event) {
        String title = buildMessage(TASK_DONE, event.getNickname());
        String body = buildMessage(DOUBLE_QUOTE, event.getTaskDetail(), DOUBLE_QUOTE);

        Map<String, String> data = Map.of(
                DATA_TYPE, NotificationDataType.ROUND.getValue(),
                STUDY_ID, event.getStudyId().toString(),
                ROUND_ID, event.getRoundId().toString(),
                ROUND_SEQ, HYPHEN
        );
        fcmUtils.sendNotificationToTopic(title, body, TopicCode.STUDY, event.getStudyId(), data);
        
        // 알림 히스토리 저장 - 스터디 주제를 구독한 사용자들에게 저장
        List<ParticipantEntity> participants = participantEntityRepository.findAllActiveByStudyId(event.getStudyId());
                
        participants.forEach(participant ->
            notificationHistoryService.saveNotificationHistory(
                participant.getUser(), 
                NotificationDataType.ROUND,
                title, 
                body, 
                data
            )
        );
    }
}
