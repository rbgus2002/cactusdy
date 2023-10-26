package ssu.groupstudy.domain.rule.api;


import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ssu.groupstudy.domain.rule.dto.request.CreateRuleRequest;
import ssu.groupstudy.domain.rule.service.RuleService;
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
    public ResponseDto register(@Valid @RequestBody CreateRuleRequest dto){
        ruleService.createRule(dto);
        return ResponseDto.success();
    }
}
