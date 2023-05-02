package ssu.groupstudy.domain.rule.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import ssu.groupstudy.domain.rule.domain.Rule;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.user.domain.User;

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
        return Rule.builder()
                .detail(this.detail)
                .study(study)
                .build();
    }
}
