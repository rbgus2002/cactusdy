package ssu.groupstudy.domain.study.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.notification.domain.event.subscribe.StudyTopicSubscribeEvent;
import ssu.groupstudy.domain.notification.domain.event.unsubscribe.NoticeTopicUnsubscribeEvent;
import ssu.groupstudy.domain.notification.domain.event.unsubscribe.StudyTopicUnsubscribeEvent;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.exception.CanNotCreateStudyException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantRepository;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.UserEntity;
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
    private final ParticipantRepository participantRepository;
    private final NoticeRepository noticeRepository;

    private final ApplicationEventPublisher eventPublisher;
    private final int PARTICIPATION_STUDY_LIMIT = 5;
    private final int INVITE_CODE_LENGTH = 6;

    @Transactional
    public Long inviteUser(UserEntity user, String inviteCode) {
        checkAddStudy(user);

        Study study = studyRepository.findByInviteCode(inviteCode)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_INVITE_CODE_NOT_FOUND));

        study.invite(user);

        addUserToFutureRounds(study, user);

        eventPublisher.publishEvent(new StudyTopicSubscribeEvent(user, study));

        return study.getStudyId();
    }

    private void checkAddStudy(UserEntity user) {
        if (participantRepository.countParticipationStudy(user) >= PARTICIPATION_STUDY_LIMIT) {
            throw new CanNotCreateStudyException(ResultCode.USER_CAN_NOT_CREATE_STUDY);
        }
    }

    private void addUserToFutureRounds(Study study, UserEntity user) {
        List<Round> futureRounds = roundRepository.findFutureRounds(study, LocalDateTime.now());
        for (Round round : futureRounds) {
            round.addParticipantWithoutDuplicates(new RoundParticipant(user, round));
        }
    }

    @Transactional
    public void leaveUser(UserEntity user, Long studyId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));
        List<Notice> notices = noticeRepository.findNoticesByStudy(study);

        removeUserToFutureRounds(study, user);
        eventPublisher.publishEvent(new StudyTopicUnsubscribeEvent(user, study));
        eventPublisher.publishEvent(new NoticeTopicUnsubscribeEvent(user, notices));
        study.leave(user);
    }

    private void removeUserToFutureRounds(Study study, UserEntity user) {
        List<Round> futureRounds = roundRepository.findFutureRounds(study, LocalDateTime.now());
        for (Round round : futureRounds) {
            round.removeParticipant(new RoundParticipant(user, round));
        }
    }

    protected String generateUniqueInviteCode() {
        String newInviteCode;
        do {
            newInviteCode = RandomStringUtils.randomNumeric(INVITE_CODE_LENGTH);
        } while (studyRepository.findByInviteCode(newInviteCode).isPresent());

        return newInviteCode;
    }
}
