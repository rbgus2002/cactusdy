package ssu.groupstudy.domain.round.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.dto.request.AppointmentRequest;
import ssu.groupstudy.domain.round.dto.response.RoundDto;
import ssu.groupstudy.domain.round.exception.RoundNotFoundException;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.global.ResultCode;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
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

    public RoundDto.RoundDetailResponse getDetail(long roundId) {
        Round round = roundRepository.findByRoundId(roundId)
                .orElseThrow(() -> new RoundNotFoundException(ResultCode.ROUND_NOT_FOUND));
        return RoundDto.createRoundDetail(round);
    }

    @Transactional
    public void updateDetail(long roundId, String detail) {
        Round round = roundRepository.findByRoundId(roundId)
                .orElseThrow(() -> new RoundNotFoundException(ResultCode.ROUND_NOT_FOUND));

        round.updateDetail(detail);
    }

    // FIXME : N+1
    // FIXME : WARNING (in console)
    public List<RoundDto.RoundInfoResponse> getRoundInfoResponses(long studyId){
        Study study = studyRepository.findByStudyId(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));

        return roundRepository.findRoundsByStudyOrderByStudyTime(study).stream()
                .map(RoundDto::createRoundInfo)
                .collect(Collectors.toList());
    }
}
