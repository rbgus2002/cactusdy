package ssu.groupstudy.domain.notification.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.notification.event.subscribe.AllUserTopicSubscribeEvent;
import ssu.groupstudy.domain.notification.event.subscribe.StudyTopicSubscribeEvent;
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
public class FcmTopicSubscribeService {
    private final ApplicationEventPublisher eventPublisher;
    private final ParticipantEntityRepository participantEntityRepository;

    public void subscribeAllUserTopic(UserEntity user) {
        eventPublisher.publishEvent(new AllUserTopicSubscribeEvent(user));
    }

    public void subscribeParticipatingStudiesTopic(UserEntity user) {
        List<StudyEntity> participatingStudies = participantEntityRepository.findByUserOrderByCreateDate(user).stream()
                .map(ParticipantEntity::getStudy)
                .collect(Collectors.toList());
        for (StudyEntity study : participatingStudies) {
            eventPublisher.publishEvent(new StudyTopicSubscribeEvent(user, study));
        }
    }
}
