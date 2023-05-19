package ssu.groupstudy.domain.round.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.dto.CreateRoundRequest;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.global.ResultCode;

@Service
@AllArgsConstructor
@Transactional(readOnly = true) // TODO : 이와 같은 Transaction 전략 세우는 이유 분석
@Slf4j
public class RoundService {

    private final StudyRepository studyRepository;
    private final RoundRepository roundRepository;

    @Transactional
    public Round createRound(CreateRoundRequest dto) {
        Study study = studyRepository.findByStudyId(dto.getStudyId())
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));

        // TODO : 스터디에 참여자 모두 UserRound 생성

        return roundRepository.save(dto.toEntity(study));
    }
}
