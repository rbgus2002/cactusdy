package ssu.groupstudy.domain.rule.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.rule.domain.Rule;
import ssu.groupstudy.domain.rule.dto.request.CreateRuleRequest;
import ssu.groupstudy.domain.rule.dto.request.UpdateRuleRequest;
import ssu.groupstudy.domain.rule.dto.response.RuleResponse;
import ssu.groupstudy.domain.rule.exception.RuleNotFoundException;
import ssu.groupstudy.domain.rule.repository.RuleRepository;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.global.constant.ResultCode;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class RuleService {
    private final StudyRepository studyRepository;
    private final RuleRepository ruleRepository;

    @Transactional
    public Long createRule(CreateRuleRequest dto) {
        StudyEntity study = studyRepository.findById(dto.getStudyId())
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));
        Rule rule = dto.toEntity(study);
        return ruleRepository.save(rule).getId();
    }

    @Transactional
    public void deleteRule(Long ruleId) {
        Rule rule = ruleRepository.findById(ruleId)
                .orElseThrow(() -> new RuleNotFoundException(ResultCode.RULE_NOT_FOUND));
        rule.delete();
    }

    @Transactional
    public void updateRule(Long ruleId, UpdateRuleRequest request) {
        Rule rule = ruleRepository.findById(ruleId)
                .orElseThrow(() -> new RuleNotFoundException(ResultCode.RULE_NOT_FOUND));
        rule.updateDetail(request.getDetail());
    }

    public List<RuleResponse> getRules(Long studyId) {
        List<Rule> rules = ruleRepository.findRulesByStudyIdOrderByCreateDate(studyId);
        return rules.stream()
                .map(RuleResponse::of)
                .collect(Collectors.toList());
    }
}
