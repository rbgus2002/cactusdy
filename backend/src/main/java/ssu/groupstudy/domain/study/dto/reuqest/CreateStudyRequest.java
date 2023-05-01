package ssu.groupstudy.domain.study.dto.reuqest;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.user.domain.User;

@Getter
@AllArgsConstructor
@Builder
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class CreateStudyRequest {
    @NotBlank(message = "이름을 입력하세요")
    private String studyName;

    @NotBlank(message = "설명을 입력하세요")
    private String detail;

    private String picture;

    @NotNull
    private Long hostUserId;

    public Study toEntity(User hostUser, String inviteLink, String inviteQRCode){
        return Study.builder()
                .studyName(this.studyName)
                .detail(this.detail)
                .picture(this.picture)
                .hostUser(hostUser)
                .inviteLink(inviteLink)
                .inviteQRCode(inviteQRCode)
                .build();
    }

}
