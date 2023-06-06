package ssu.groupstudy.domain.round.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.round.dto.AppointmentRequest;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.global.ResultCode;

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
}
