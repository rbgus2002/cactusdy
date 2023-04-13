package ssu.groupstudy.domain.study.dto.reuqest;

import jakarta.persistence.Column;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.user.domain.User;

@Getter
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class RegisterStudyRequest {
    @NotBlank(message = "이름을 입력하세요")
    private String studyName;

    @NotBlank(message = "설명을 입력하세요")
    private String detail;

    private String picture;

    @NotEmpty(message = "방장의 userId를 입력하세요")
    private Long hostUserId;

    // TODO : 마저 개발하기
//    public Study toEntity(){
//        return Study.builder()
//                .
//                .build()
//    }

}
