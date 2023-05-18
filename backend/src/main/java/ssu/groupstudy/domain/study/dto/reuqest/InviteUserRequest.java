package ssu.groupstudy.domain.study.dto.reuqest;

import lombok.*;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.domain.UserStudy;
import ssu.groupstudy.domain.user.domain.User;

import javax.validation.constraints.NotNull;

@Getter
@AllArgsConstructor
@Builder
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class InviteUserRequest {
    @NotNull
    private Long userId;

    @NotNull
    private Long studyId;

    public UserStudy toEntity(User user, Study study){
        return UserStudy.builder()
                .user(user)
                .study(study)
                .build();
    }
}
