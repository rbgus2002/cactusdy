package ssu.groupstudy.domain.rule.api;


import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.rule.dto.request.CreateRuleRequest;
import ssu.groupstudy.domain.rule.dto.request.UpdateRuleRequest;
import ssu.groupstudy.domain.rule.dto.response.RuleResponse;
import ssu.groupstudy.domain.rule.service.RuleService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/rules")
@RequiredArgsConstructor
@Tag(name = "RuleEntity", description = "규칙 API")
public class RuleApi {
    private final RuleService ruleService;

    @Operation(summary = "규칙 생성")
    @PostMapping
    public ResponseDto createRule(@Valid @RequestBody CreateRuleRequest dto){
        Long ruleId = ruleService.createRule(dto);
        return DataResponseDto.of("ruleId", ruleId);
    }

    @Operation(summary = "규칙 삭제")
    @DeleteMapping("/{ruleId}")
    public ResponseDto deleteRule(@PathVariable Long ruleId){
        ruleService.deleteRule(ruleId);
        return ResponseDto.success();
    }

    @Operation(summary = "규칙 수정")
    @PutMapping("/{ruleId}")
    public ResponseDto updateRule(@PathVariable Long ruleId, @Valid @RequestBody UpdateRuleRequest request){
        ruleService.updateRule(ruleId, request);
        return ResponseDto.success();
    }

    @Operation(summary = "규칙 조회", description = "특정 스터디의 규칙을 모두 조회한다.")
    @GetMapping("{studyId}")
    public ResponseDto getRules(@PathVariable Long studyId){
        List<RuleResponse> rules = ruleService.getRules(studyId);
        return DataResponseDto.of("rules", rules);
    }
}
