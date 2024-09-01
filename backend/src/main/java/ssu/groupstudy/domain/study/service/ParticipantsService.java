package ssu.groupstudy.domain.study.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.domain.notice.repository.NoticeEntityRepository;
import ssu.groupstudy.domain.round.entity.RoundEntity;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.domain.common.enums.StatusTag;
import ssu.groupstudy.domain.round.repository.RoundEntityRepository;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.param.DoneCount;
import ssu.groupstudy.domain.study.param.ParticipantInfo;
import ssu.groupstudy.domain.study.param.StatusTagInfo;
import ssu.groupstudy.api.study.vo.ParticipantResVo;
import ssu.groupstudy.api.study.vo.ParticipantSummaryResVo;
import ssu.groupstudy.domain.notification.event.unsubscribe.NoticeTopicUnsubscribeEvent;
import ssu.groupstudy.domain.notification.event.unsubscribe.StudyTopicUnsubscribeEvent;
import ssu.groupstudy.domain.study.exception.CanNotKickParticipantException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantEntityRepository;
import ssu.groupstudy.domain.study.repository.StudyEntityRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;

import java.time.LocalDateTime;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static ssu.groupstudy.domain.common.enums.ResultCode.*;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class ParticipantsService {
    private final StudyEntityRepository studyEntityRepository;
    private final UserEntityRepository userEntityRepository;
    private final ParticipantEntityRepository participantEntityRepository;
    private final RoundEntityRepository roundEntityRepository;
    private final NoticeEntityRepository noticeEntityRepository;
    private final ApplicationEventPublisher eventPublisher;

    public List<ParticipantSummaryResVo> getParticipantsProfileImageList(Long studyId) {
        StudyEntity study = studyEntityRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));

        List<ParticipantEntity> participantList = getParticipantListOrderByCreateDateAsc(study);
        return participantList.stream()
                .map(ParticipantSummaryResVo::from)
                .collect(Collectors.toList());
    }

    private List<ParticipantEntity> getParticipantListOrderByCreateDateAsc(StudyEntity study) {
        return study.getParticipantList().stream()
                .sorted(Comparator.comparing((ParticipantEntity p) -> !p.getUser().equals(study.getHostUser()))
                        .thenComparing(ParticipantEntity::getCreateDate))
                .collect(Collectors.toList());
    }

    public ParticipantResVo getParticipant(Long userId, Long studyId) {
        StudyEntity study = studyEntityRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));
        UserEntity user = userEntityRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(USER_NOT_FOUND));

        List<ParticipantInfo> participantInfoList = participantEntityRepository.findParticipantInfoByUser(user);
        List<StatusTagInfo> statusTagInfoList = handleStatusTagInfo(study, user);
        DoneCount doneCount = studyEntityRepository.calculateDoneCount(user, study);
        char isParticipated = (study.isParticipated(user)) ? 'Y' : 'N';

        return ParticipantResVo.of(user, participantInfoList, statusTagInfoList, doneCount, isParticipated);
    }

    private List<StatusTagInfo> handleStatusTagInfo(StudyEntity study, UserEntity user) {
        List<StatusTagInfo> statusTagInfos = studyEntityRepository.calculateStatusTag(user, study);
        Map<StatusTag, StatusTagInfo> statusTagInfoMap = statusTagInfos.stream()
                .collect(Collectors.toMap(StatusTagInfo::getStatusTag, Function.identity()));

        for (StatusTag tag : StatusTag.values()) {
            statusTagInfoMap.putIfAbsent(tag, new StatusTagInfo(tag, 0L));
        }
        return new ArrayList<>(statusTagInfoMap.values());
    }

    @Transactional
    public void kickParticipant(UserEntity host, Long targetUserId, Long studyId) {
        StudyEntity study = studyEntityRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));
        UserEntity targetUser = userEntityRepository.findById(targetUserId)
                .orElseThrow(() -> new UserNotFoundException(USER_NOT_FOUND));
        List<NoticeEntity> notices = noticeEntityRepository.findNoticesByStudy(study);

        assertUserIsHostOrThrow(host, study);

        removeUserToFutureRounds(study, targetUser);
        eventPublisher.publishEvent(StudyTopicUnsubscribeEvent.builder()
                .fcmTokens(targetUser.getFcmTokens())
                .studyId(study.getStudyId())
                .build()
        );
        eventPublisher.publishEvent(new NoticeTopicUnsubscribeEvent(targetUser, notices));
        study.kickParticipant(targetUser);
    }

    private void removeUserToFutureRounds(StudyEntity study, UserEntity user) {
        List<RoundEntity> futureRounds = roundEntityRepository.findFutureRounds(study, LocalDateTime.now());
        for (RoundEntity round : futureRounds) {
            round.removeParticipant(new RoundParticipantEntity(user, round));
        }
    }

    private void assertUserIsHostOrThrow(UserEntity host, StudyEntity study) {
        if(!study.isHostUser(host)) {
            throw new CanNotKickParticipantException(USER_CAN_NOT_KICK_PARTICIPANT);
        }
    }
}
