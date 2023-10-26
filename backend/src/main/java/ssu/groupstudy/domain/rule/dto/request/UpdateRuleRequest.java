package ssu.groupstudy.domain.rule.dto.request;

import lombok.Getter;

import javax.validation.constraints.NotBlank;

@Getter
public class UpdateRuleRequest {
    @NotBlank
    private String detail;
}
