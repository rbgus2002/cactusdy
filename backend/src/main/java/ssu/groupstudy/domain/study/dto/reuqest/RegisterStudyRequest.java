package ssu.groupstudy.domain.study.dto.reuqest;

import jakarta.persistence.Column;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
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

    @NotNull
    private Long hostUserId;

    public Study toEntityWithUser(User hostUser){ // TODO : User 부분 어떻게 넣어줄 건지 레퍼런스 참고
        return Study.builder()
                .studyName(this.studyName)
                .detail(this.detail)
                .picture(this.picture)
                .hostUser(hostUser)
                .build();
    }

}
