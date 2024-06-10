package ssu.groupstudy.domain.rule.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.rule.entity.RuleEntity;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class RuleResponse {
    private Long ruleId;
    private String detail;

    private RuleResponse(RuleEntity rule) {
        this.ruleId = rule.getId();
        this.detail = rule.getDetail();
    }

    public static RuleResponse of(RuleEntity rule){
        return new RuleResponse(rule);
    }
}
