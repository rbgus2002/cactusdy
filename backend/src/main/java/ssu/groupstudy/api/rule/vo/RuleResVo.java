package ssu.groupstudy.api.rule.vo;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.rule.entity.RuleEntity;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class RuleResVo {
    private Long ruleId;
    private String detail;

    private RuleResVo(RuleEntity rule) {
        this.ruleId = rule.getId();
        this.detail = rule.getDetail();
    }

    public static RuleResVo of(RuleEntity rule){
        return new RuleResVo(rule);
    }
}
