package ssu.groupstudy.domain.rule.dto.request;

import lombok.Builder;
import lombok.Getter;
import ssu.groupstudy.domain.rule.domain.Rule;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.user.domain.User;

@Builder
@Getter
public class CreateRuleRequest {
    private Long studyId;
    private String detail;

    public Rule toEntity(Study study){
        return Rule.builder()
                .detail(this.detail)
                .study(study)
                .build();
    }
}
