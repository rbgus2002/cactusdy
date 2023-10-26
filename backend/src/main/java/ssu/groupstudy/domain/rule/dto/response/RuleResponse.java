package ssu.groupstudy.domain.rule.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.rule.domain.Rule;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class RuleResponse {
    private Long ruleId;
    private String detail;

    private RuleResponse(Rule rule) {
        this.ruleId = rule.getId();
        this.detail = rule.getDetail();
    }

    public static RuleResponse of(Rule rule){
        return new RuleResponse(rule);
    }
}
