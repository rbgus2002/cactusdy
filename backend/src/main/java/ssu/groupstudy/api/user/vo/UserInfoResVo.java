package ssu.groupstudy.api.user.vo;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.entity.UserEntity;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class UserInfoResVo {
    private Long userId;
    private String nickname;
    private String statusMessage;
    private String profileImage;

    public UserInfoResVo(UserEntity user){
        this.userId = user.getUserId();
        this.nickname = user.getNickname();
        this.statusMessage = user.getStatusMessage();
        this.profileImage = user.getPicture();
    }

    public static UserInfoResVo from(UserEntity user) {
        return new UserInfoResVo(user);
    }
}