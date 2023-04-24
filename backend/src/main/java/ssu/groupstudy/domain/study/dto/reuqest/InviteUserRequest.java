package ssu.groupstudy.domain.study.dto.reuqest;

import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.domain.StudyInfoPerUser;
import ssu.groupstudy.domain.study.service.StudyInviteService;
import ssu.groupstudy.domain.user.domain.User;

@Getter
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class InviteUserRequest {
    @NotNull
    private Long userId;

    @NotNull
    private Long studyId;

    public StudyInfoPerUser toEntity(User user, Study study){ // TODO : User, Study 부분 어떻게 넣어줄 건지 레퍼런스 참고
        return new StudyInfoPerUser(user, study);
    }
}
