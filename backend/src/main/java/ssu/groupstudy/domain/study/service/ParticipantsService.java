package ssu.groupstudy.domain.study.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.round.domain.StatusTag;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.DoneCount;
import ssu.groupstudy.domain.study.dto.StatusTagInfo;
import ssu.groupstudy.domain.study.dto.response.ParticipantResponse;
import ssu.groupstudy.domain.study.dto.response.ParticipantSummaryResponse;
import ssu.groupstudy.domain.study.exception.ParticipantNotFoundException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantRepository;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;

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

    public List<ParticipantSummaryResponse> getParticipantsProfileImageList(Long studyId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));

        List<Participant> participantList = getParticipantListOrderByCreateDateAsc(study);
        return participantList.stream()
                .map(ParticipantSummaryResponse::from)
                .collect(Collectors.toList());
    }

    private List<Participant> getParticipantListOrderByCreateDateAsc(Study study) {
        return study.getParticipants().stream()
                .sorted(Comparator.comparing(Participant::getCreateDate))
                .collect(Collectors.toList());
    }

    @Transactional
    public void modifyColor(Long participantId, String colorCode) {
        Participant participant = participantRepository.findById(participantId)
                .orElseThrow(() -> new ParticipantNotFoundException(PARTICIPANT_NOT_FOUND));
        participant.setColor(colorCode);
    }

    public ParticipantResponse getParticipant(Long userId, Long studyId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(USER_NOT_FOUND));

        List<String> studyNames = participantRepository.findStudyNamesByUser(user);
        List<StatusTagInfo> statusTagInfo = handleStatusTagInfo(study, user);
        DoneCount doneCount = studyRepository.calculateDoneCount(user, study);

        return ParticipantResponse.of(user, studyNames, statusTagInfo, doneCount);
    }

    private List<StatusTagInfo> handleStatusTagInfo(Study study, User user) {
        List<StatusTagInfo> statusTagInfos = studyRepository.calculateStatusTag(user, study);
        EnumSet<StatusTag> statusTags = EnumSet.allOf(StatusTag.class);

        Map<StatusTag, StatusTagInfo> statusTagInfoMap = statusTagInfos.stream()
                .collect(Collectors.toMap(StatusTagInfo::getStatusTag, Function.identity()));

        for (StatusTag tag : statusTags) {
            statusTagInfoMap.computeIfAbsent(tag, t -> new StatusTagInfo(t, 0L));
        }

        return new ArrayList<>(statusTagInfoMap.values());
    }
}
