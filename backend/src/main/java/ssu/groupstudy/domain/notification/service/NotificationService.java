package ssu.groupstudy.domain.notification.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import ssu.groupstudy.domain.common.enums.TopicCode;
import ssu.groupstudy.domain.notification.param.NotificationParam;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.study.repository.ParticipantEntityRepository;
import ssu.groupstudy.global.util.FcmUtils;

import javax.annotation.Nullable;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class NotificationService {
    private final FcmUtils fcmUtils;
    private final NotificationHistoryService notificationHistoryService;
    private final ParticipantEntityRepository participantEntityRepository;

    @Async
    public void push(NotificationParam param) {
        fcmUtils.sendNotificationToTopic(
                param.getTitle(),
                param.getBody(),
                param.getTopicCode(),
                param.getTopicId(),
                param.getData()
        );
        saveNotificationHistory(param);
    }

    @Async
    public void subscribeToFcm(List<String> fcmTokens, TopicCode topicCode, @Nullable Long id) {
        fcmUtils.subscribeTopicFor(fcmTokens, topicCode, id);
    }

    @Async
    public void unsubscribeToFcm(List<String> fcmTokens, TopicCode topicCode, @Nullable Long id) {
        fcmUtils.unsubscribeTopicFor(fcmTokens, topicCode, id);
    }

    private void saveNotificationHistory(NotificationParam param) {
        Long studyId = param.getStudyId();
        if (studyId == null) {
            log.debug("Skip saveNotificationHistory: studyId is null");
            return;
        }

        List<ParticipantEntity> participants = participantEntityRepository.findAllActiveByStudyId(studyId);
        participants.forEach(participant ->
                notificationHistoryService.saveNotificationHistory(
                        participant.getUser(),
                        param.getNotificationDataType(),
                        param.getTitle(),
                        param.getBody(),
                        param.getData()
                )
        );
    }
}
