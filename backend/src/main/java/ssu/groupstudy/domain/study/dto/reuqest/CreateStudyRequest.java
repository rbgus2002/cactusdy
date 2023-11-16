package ssu.groupstudy.domain.study.dto.reuqest;

import lombok.*;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.user.domain.User;

import javax.validation.constraints.NotBlank;

@Getter
@AllArgsConstructor
@Builder
@NoArgsConstructor(access = AccessLevel.PRIVATE)
@ToString
public class CreateStudyRequest {
    @NotBlank(message = "이름을 입력하세요")
    private String studyName;

    @NotBlank(message = "설명을 입력하세요")
    private String detail;

    @NotBlank(message = "색상을 입력하세요")
    private String color;

    public Study toEntity(User hostUser){
        return Study.builder()
                .studyName(this.studyName)
                .detail(this.detail)
                .color(this.color)
                .hostUser(hostUser)
                .build();
    }
}
