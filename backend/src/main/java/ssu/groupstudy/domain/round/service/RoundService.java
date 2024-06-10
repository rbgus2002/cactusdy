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
import ssu.groupstudy.domain.user.domain.UserEntity;

import java.util.List;
import java.util.stream.Collectors;

import static ssu.groupstudy.global.constant.ResultCode.*;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class RoundService {
    private final StudyRepository studyRepository;
    private final RoundRepository roundRepository;
    private final int ROUND_LIMIT = 60;

    @Transactional
    public long createRound(long studyId, AppointmentRequest dto) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));
        checkRoundMoreThanLimit(study);
        return roundRepository.save(dto.toEntity(study)).getRoundId();
    }

    private void checkRoundMoreThanLimit(Study study) {
        if (roundRepository.countRoundsByStudy(study) >= ROUND_LIMIT) {
            throw new IllegalStateException(USER_CAN_NOT_CREATE_ROUND.getMessage());
        }
    }

    @Transactional
    public void updateAppointment(long roundId, AppointmentRequest dto) {
        Round round = roundRepository.findById(roundId)
                .orElseThrow(() -> new RoundNotFoundException(ROUND_NOT_FOUND));
        round.updateAppointment(dto.toAppointment());
    }

    public RoundDto.RoundDetailResponse getDetail(long roundId) {
        Round round = roundRepository.findById(roundId)
                .orElseThrow(() -> new RoundNotFoundException(ROUND_NOT_FOUND));
        return RoundDto.createRoundDetail(round);
    }

    @Transactional
    public void updateDetail(long roundId, String detail) {
        Round round = roundRepository.findById(roundId)
                .orElseThrow(() -> new RoundNotFoundException(ROUND_NOT_FOUND));
        round.updateDetail(detail);
    }

    public List<RoundDto.RoundInfoResponse> getRoundInfoResponses(long studyId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));
        return roundRepository.findRoundsByStudyOrderByStudyTime(study).stream()
                .map(RoundDto::createRoundInfo)
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteRound(long roundId, UserEntity user) {
        Round round = roundRepository.findById(roundId)
                .orElseThrow(() -> new RoundNotFoundException(ROUND_NOT_FOUND));
        round.deleteRound(user);
    }
}
