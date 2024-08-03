package ssu.groupstudy.domain.study.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.domain.notice.repository.NoticeEntityRepository;
import ssu.groupstudy.domain.notification.event.subscribe.StudyTopicSubscribeEvent;
import ssu.groupstudy.domain.notification.event.unsubscribe.NoticeTopicUnsubscribeEvent;
import ssu.groupstudy.domain.notification.event.unsubscribe.StudyTopicUnsubscribeEvent;
import ssu.groupstudy.domain.round.entity.RoundEntity;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.exception.CanNotCreateStudyException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantEntityRepository;
import ssu.groupstudy.domain.study.repository.StudyEntityRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class StudyInviteService {
    private final UserEntityRepository userEntityRepository;
    private final StudyEntityRepository studyEntityRepository;
    private final RoundRepository roundRepository;
    private final ParticipantEntityRepository participantEntityRepository;
    private final NoticeEntityRepository noticeEntityRepository;

    private final ApplicationEventPublisher eventPublisher;
    private final int PARTICIPATION_STUDY_LIMIT = 5;
    private final int INVITE_CODE_LENGTH = 6;

    @Transactional
    public Long inviteUser(Long userId, String inviteCode) {
        UserEntity user = userEntityRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        checkAddStudy(user);

        StudyEntity study = studyEntityRepository.findByInviteCode(inviteCode)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_INVITE_CODE_NOT_FOUND));

        study.invite(user);

        addUserToFutureRounds(study, user);

        eventPublisher.publishEvent(new StudyTopicSubscribeEvent(user, study));

        return study.getStudyId();
    }

    private void checkAddStudy(UserEntity user) {
        if (participantEntityRepository.countParticipationStudy(user) >= PARTICIPATION_STUDY_LIMIT) {
            throw new CanNotCreateStudyException(ResultCode.USER_CAN_NOT_CREATE_STUDY);
        }
    }

    private void addUserToFutureRounds(StudyEntity study, UserEntity user) {
        List<RoundEntity> futureRounds = roundRepository.findFutureRounds(study, LocalDateTime.now());
        for (RoundEntity round : futureRounds) {
            round.addParticipantWithoutDuplicates(new RoundParticipantEntity(user, round));
        }
    }

    @Transactional
    public void leaveUser(Long userId, Long studyId) {
        UserEntity user = userEntityRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));
        StudyEntity study = studyEntityRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));
        List<NoticeEntity> notices = noticeEntityRepository.findNoticesByStudy(study);

        removeUserToFutureRounds(study, user);
        eventPublisher.publishEvent(new StudyTopicUnsubscribeEvent(user, study));
        eventPublisher.publishEvent(new NoticeTopicUnsubscribeEvent(user, notices));
        study.leave(user);
    }

    private void removeUserToFutureRounds(StudyEntity study, UserEntity user) {
        List<RoundEntity> futureRounds = roundRepository.findFutureRounds(study, LocalDateTime.now());
        for (RoundEntity round : futureRounds) {
            round.removeParticipant(new RoundParticipantEntity(user, round));
        }
    }

    protected String generateUniqueInviteCode() {
        String newInviteCode;
        do {
            newInviteCode = RandomStringUtils.randomNumeric(INVITE_CODE_LENGTH);
        } while (studyEntityRepository.findByInviteCode(newInviteCode).isPresent());

        return newInviteCode;
    }
}
