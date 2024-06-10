package ssu.groupstudy.domain.study.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.round.domain.StatusTag;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.DoneCount;
import ssu.groupstudy.domain.study.dto.ParticipantInfo;
import ssu.groupstudy.domain.study.dto.StatusTagInfo;
import ssu.groupstudy.domain.study.dto.response.ParticipantResponse;
import ssu.groupstudy.domain.study.dto.response.ParticipantSummaryResponse;
import ssu.groupstudy.domain.notification.domain.event.unsubscribe.NoticeTopicUnsubscribeEvent;
import ssu.groupstudy.domain.notification.domain.event.unsubscribe.StudyTopicUnsubscribeEvent;
import ssu.groupstudy.domain.study.exception.CanNotKickParticipantException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantRepository;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.UserEntity;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;

import java.time.LocalDateTime;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static ssu.groupstudy.global.constant.ResultCode.*;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class ParticipantsService {
    private final StudyRepository studyRepository;
    private final UserRepository userRepository;
    private final ParticipantRepository participantRepository;
    private final RoundRepository roundRepository;
    private final NoticeRepository noticeRepository;
    private final ApplicationEventPublisher eventPublisher;

    public List<ParticipantSummaryResponse> getParticipantsProfileImageList(Long studyId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));

        List<Participant> participantList = getParticipantListOrderByCreateDateAsc(study);
        return participantList.stream()
                .map(ParticipantSummaryResponse::from)
                .collect(Collectors.toList());
    }

    private List<Participant> getParticipantListOrderByCreateDateAsc(Study study) {
        return study.getParticipantList().stream()
                .sorted(Comparator.comparing((Participant p) -> !p.getUser().equals(study.getHostUser()))
                        .thenComparing(Participant::getCreateDate))
                .collect(Collectors.toList());
    }

    public ParticipantResponse getParticipant(Long userId, Long studyId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));
        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(USER_NOT_FOUND));

        List<ParticipantInfo> participantInfoList = participantRepository.findParticipantInfoByUser(user);
        List<StatusTagInfo> statusTagInfoList = handleStatusTagInfo(study, user);
        DoneCount doneCount = studyRepository.calculateDoneCount(user, study);
        char isParticipated = (study.isParticipated(user)) ? 'Y' : 'N';

        return ParticipantResponse.of(user, participantInfoList, statusTagInfoList, doneCount, isParticipated);
    }

    private List<StatusTagInfo> handleStatusTagInfo(Study study, UserEntity user) {
        List<StatusTagInfo> statusTagInfos = studyRepository.calculateStatusTag(user, study);
        Map<StatusTag, StatusTagInfo> statusTagInfoMap = statusTagInfos.stream()
                .collect(Collectors.toMap(StatusTagInfo::getStatusTag, Function.identity()));

        for (StatusTag tag : StatusTag.values()) {
            statusTagInfoMap.putIfAbsent(tag, new StatusTagInfo(tag, 0L));
        }
        return new ArrayList<>(statusTagInfoMap.values());
    }

    @Transactional
    public void kickParticipant(UserEntity user, Long userId, Long studyId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));
        UserEntity targetUser = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(USER_NOT_FOUND));
        List<Notice> notices = noticeRepository.findNoticesByStudy(study);

        assertUserIsHostOrThrow(user, study);

        removeUserToFutureRounds(study, targetUser);
        eventPublisher.publishEvent(new StudyTopicUnsubscribeEvent(user, study));
        eventPublisher.publishEvent(new NoticeTopicUnsubscribeEvent(user, notices));
        study.kickParticipant(targetUser);
    }

    private void removeUserToFutureRounds(Study study, UserEntity user) {
        List<Round> futureRounds = roundRepository.findFutureRounds(study, LocalDateTime.now());
        for (Round round : futureRounds) {
            round.removeParticipant(new RoundParticipant(user, round));
        }
    }

    private void assertUserIsHostOrThrow(UserEntity user, Study study) {
        if(!study.isHostUser(user)) {
            throw new CanNotKickParticipantException(USER_CAN_NOT_KICK_PARTICIPANT);
        }
    }
}
