package ssu.groupstudy.api.user.vo;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.param.UserParam;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class UserInfoResVo {
    private Long userId;
    private String nickname;
    private String statusMessage;
    private String profileImage;

    public static UserInfoResVo from(UserParam user) {
        return new UserInfoResVo(user.getUserId(), user.getNickname(), user.getStatusMessage(), user.getProfileImage());
    }
}