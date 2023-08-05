package ssu.groupstudy.domain.round.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.dto.request.AppointmentRequest;
import ssu.groupstudy.domain.round.dto.response.RoundInfoResponse;
import ssu.groupstudy.domain.round.exception.RoundNotFoundException;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.global.ResultCode;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class RoundService {
    private final StudyRepository studyRepository;
    private final RoundRepository roundRepository;

    @Transactional
    public Long createRound(Long studyId, AppointmentRequest dto) {
        Study study = studyRepository.findByStudyId(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));

        return roundRepository.save(dto.toEntity(study)).getRoundId();
    }

    @Transactional
    public void updateAppointment(long roundId, AppointmentRequest dto) {
        Round round = roundRepository.findByRoundId(roundId)
                .orElseThrow(() -> new RoundNotFoundException(ResultCode.ROUND_NOT_FOUND));

        round.updateAppointment(dto.toAppointment());
    }

    @Transactional
    public void updateDetail(long roundId, String detail) {
        Round round = roundRepository.findByRoundId(roundId)
                .orElseThrow(() -> new RoundNotFoundException(ResultCode.ROUND_NOT_FOUND));

        round.updateDetail(detail);
    }

    public List<RoundInfoResponse> getRoundInfoResponses(long studyId){
        Study study = studyRepository.findByStudyId(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));

        List<Round> rounds = roundRepository.findRoundsByStudy(study);
        return rounds.stream()
                .map(RoundInfoResponse::from)
                .collect(Collectors.toList());
    }
}
