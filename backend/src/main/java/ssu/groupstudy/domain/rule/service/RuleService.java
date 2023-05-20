package ssu.groupstudy.domain.rule.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.rule.domain.Rule;
import ssu.groupstudy.domain.rule.dto.request.CreateRuleRequest;
import ssu.groupstudy.domain.rule.repository.RuleRepository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.global.ResultCode;

@Service
@AllArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class RuleService {
    private final StudyRepository studyRepository;
    private final RuleRepository ruleRepository;

    @Transactional
    public void createRule(CreateRuleRequest dto) {
        Study study = studyRepository.findByStudyId(dto.getStudyId())
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));

        ruleRepository.save(dto.toEntity(study));
    }
}
