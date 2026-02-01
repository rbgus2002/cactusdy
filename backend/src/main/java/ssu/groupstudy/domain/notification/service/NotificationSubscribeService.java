package ssu.groupstudy.domain.notification.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.common.enums.TopicCode;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.repository.ParticipantEntityRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class NotificationSubscribeService {
    private final ParticipantEntityRepository participantEntityRepository;
    private final NotificationService notificationService;

    public void subscribeAllUserTopic(UserEntity user) {
        notificationService.subscribeToFcm(user.getFcmTokens(), TopicCode.ALL_USERS, null);
    }

    public void subscribeParticipatingStudiesTopic(UserEntity user) {
        List<StudyEntity> participatingStudies = participantEntityRepository.findAllByUserOrderByCreateDate(user).stream()
                .map(ParticipantEntity::getStudy)
                .collect(Collectors.toList());

        participatingStudies.forEach(study ->
                notificationService.subscribeToFcm(user.getFcmTokens(), TopicCode.STUDY, study.getStudyId())
        );
    }
}
