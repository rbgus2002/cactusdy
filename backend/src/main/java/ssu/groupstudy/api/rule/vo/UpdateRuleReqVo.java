package ssu.groupstudy.api.rule.vo;

import lombok.Getter;

import javax.validation.constraints.NotBlank;

@Getter
public class UpdateRuleReqVo {
    @NotBlank
    private String detail;
}
