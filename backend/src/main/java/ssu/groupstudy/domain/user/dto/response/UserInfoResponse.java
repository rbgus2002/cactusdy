package ssu.groupstudy.domain.user.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.entity.UserEntity;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class UserInfoResponse {
    private Long userId;
    private String nickname;
    private String statusMessage;
    private String profileImage;

    public UserInfoResponse(UserEntity user){
        this.userId = user.getUserId();
        this.nickname = user.getNickname();
        this.statusMessage = user.getStatusMessage();
        this.profileImage = user.getPicture();
    }

    public static UserInfoResponse from(UserEntity user) {
        return new UserInfoResponse(user);
    }
}