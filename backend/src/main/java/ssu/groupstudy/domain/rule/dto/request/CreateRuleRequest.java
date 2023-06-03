package ssu.groupstudy.domain.rule.dto.request;

import lombok.*;
import ssu.groupstudy.domain.rule.domain.Rule;
import ssu.groupstudy.domain.study.domain.Study;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PRIVATE)
@Getter
public class CreateRuleRequest {
    @NotNull
    private Long studyId;
    @NotBlank
    private String detail;

    public Rule toEntity(Study study){
        return new Rule(this.detail, study);
    }
}
