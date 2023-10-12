package ssu.groupstudy.domain.study.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.round.repository.RoundParticipantRepository;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.response.StudyInfoResponse;
import ssu.groupstudy.domain.study.dto.response.StudySummaryResponse;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.exception.ParticipantNotFoundException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantRepository;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.ResultCode;

import java.util.List;
import java.util.stream.Collectors;


@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class StudyService {
    private final StudyRepository studyRepository;
    private final ParticipantRepository participantRepository;
    private final RoundRepository roundRepository;
    private final RoundParticipantRepository roundParticipantRepository;

    @Transactional
    public Long createStudy(CreateStudyRequest dto, User user) {
        return studyRepository.save(dto.toEntity(user)).getStudyId();
    }

    public StudySummaryResponse getStudySummary(long studyId, User user) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));
        Participant participant = participantRepository.findByUserAndStudy(user, study)
                .orElseThrow(() -> new ParticipantNotFoundException(ResultCode.PARTICIPANT_NOT_FOUND));
        return StudySummaryResponse.from(study, participant);
    }

    // TODO : Batch Size 설정 후 DB query 횟수 비교 (최적화 잘 되는지 확인)
    public List<StudyInfoResponse> getStudies(User user) {
        List<Participant> participants = participantRepository.findByUserOrderByCreateDate(user);
        return participants.stream()
                .map(this::createStudyInfo)
                .collect(Collectors.toList());
    }

    private StudyInfoResponse createStudyInfo(Participant participant) {
        Study study = participant.getStudy();

        Long roundSeq = handleRoundSeq(study);
        Round latestRound = roundRepository.findLatestRound(study.getStudyId()).orElse(null);
        RoundParticipant roundParticipant = roundParticipantRepository.findByUserAndRound(participant.getUser(), latestRound).orElse(null);

        return StudyInfoResponse.of(participant, roundSeq, latestRound, roundParticipant);
    }

    private long handleRoundSeq(Study study) {
        long roundSeq = roundRepository.countRoundByStudy(study);
        if (roundSeq == 0) {
            roundSeq = 1;
        }
        return roundSeq;
    }
}
