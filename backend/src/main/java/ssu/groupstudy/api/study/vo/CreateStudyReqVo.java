package ssu.groupstudy.api.study.vo;

import lombok.*;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

import javax.validation.constraints.NotBlank;

@Getter
@AllArgsConstructor
@Builder
@NoArgsConstructor(access = AccessLevel.PRIVATE)
@ToString
public class CreateStudyReqVo {
    @NotBlank(message = "이름을 입력하세요")
    private String studyName;

    @NotBlank(message = "설명을 입력하세요")
    private String detail;

    @NotBlank(message = "색상을 입력하세요")
    private String color;

    public StudyEntity toEntity(UserEntity hostUser, String inviteCode){
        return StudyEntity.init(this.studyName, this.detail, this.color, hostUser, inviteCode);
    }
}
