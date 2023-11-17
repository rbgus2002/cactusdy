package ssu.groupstudy.domain.study.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.notification.domain.event.subscribe.StudyTopicSubscribeEvent;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.round.repository.RoundParticipantRepository;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.constant.ResultCode;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class StudyInviteService {
    private final StudyRepository studyRepository;
    private final RoundRepository roundRepository;
    private final RoundParticipantRepository roundParticipantRepository;
    private final ApplicationEventPublisher eventPublisher;

    @Transactional
    public void inviteUser(User user, Long studyId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));
        study.invite(user);
        addUserToFutureRounds(study, user);
        eventPublisher.publishEvent(new StudyTopicSubscribeEvent(user, study));
    }

    private void addUserToFutureRounds(Study study, User user) {
        List<Round> futureRounds = roundRepository.findFutureRounds(study, LocalDateTime.now());
        for (Round round : futureRounds) {
            roundParticipantRepository.save(new RoundParticipant(user, round));
        }
    }

    @Transactional
    public void leaveUser(User user, Long studyId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));
        study.leave(user);
    }
}
