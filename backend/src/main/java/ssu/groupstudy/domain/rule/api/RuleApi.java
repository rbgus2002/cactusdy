package ssu.groupstudy.domain.rule.api;


import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.rule.dto.request.CreateRuleRequest;
import ssu.groupstudy.domain.rule.dto.request.UpdateRuleRequest;
import ssu.groupstudy.domain.rule.service.RuleService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/rules")
@RequiredArgsConstructor
@Tag(name = "Rule", description = "규칙 API")
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

}
