package ssu.groupstudy.api.rule.controller;


import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.api.rule.vo.CreateRuleReqVo;
import ssu.groupstudy.api.rule.vo.UpdateRuleReqVo;
import ssu.groupstudy.api.rule.vo.RuleResVo;
import ssu.groupstudy.domain.rule.service.RuleService;
import ssu.groupstudy.api.common.vo.DataResVo;
import ssu.groupstudy.api.common.vo.ResVo;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/rules")
@RequiredArgsConstructor
@Tag(name = "RuleEntity", description = "규칙 API")
public class RuleController {
    private final RuleService ruleService;

    @Operation(summary = "규칙 생성")
    @PostMapping
    public ResVo createRule(@Valid @RequestBody CreateRuleReqVo dto){
        Long ruleId = ruleService.createRule(dto);
        return DataResVo.of("ruleId", ruleId);
    }

    @Operation(summary = "규칙 삭제")
    @DeleteMapping("/{ruleId}")
    public ResVo deleteRule(@PathVariable Long ruleId){
        ruleService.deleteRule(ruleId);
        return ResVo.success();
    }

    @Operation(summary = "규칙 수정")
    @PutMapping("/{ruleId}")
    public ResVo updateRule(@PathVariable Long ruleId, @Valid @RequestBody UpdateRuleReqVo request){
        ruleService.updateRule(ruleId, request);
        return ResVo.success();
    }

    @Operation(summary = "규칙 조회", description = "특정 스터디의 규칙을 모두 조회한다.")
    @GetMapping("{studyId}")
    public ResVo getRules(@PathVariable Long studyId){
        List<RuleResVo> rules = ruleService.getRules(studyId);
        return DataResVo.of("rules", rules);
    }
}
