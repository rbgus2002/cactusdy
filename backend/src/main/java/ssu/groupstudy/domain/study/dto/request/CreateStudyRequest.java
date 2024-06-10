package ssu.groupstudy.domain.study.dto.request;

import lombok.*;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.user.domain.UserEntity;

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

    public Study toEntity(UserEntity hostUser, String inviteCode){
        return Study.init(this.studyName, this.detail, this.color, hostUser, inviteCode);
    }
}
