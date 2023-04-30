package ssu.groupstudy.domain.study.dto.reuqest;

import jakarta.validation.constraints.NotNull;
import lombok.*;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.domain.StudyPerUser;
import ssu.groupstudy.domain.user.domain.User;

@Getter
@AllArgsConstructor
@Builder
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class InviteUserRequest {
    @NotNull
    private Long userId;

    @NotNull
    private Long studyId;

    public StudyPerUser toEntity(User user, Study study){
        return StudyPerUser.builder()
                .user(user)
                .study(study)
                .build();
    }
}
