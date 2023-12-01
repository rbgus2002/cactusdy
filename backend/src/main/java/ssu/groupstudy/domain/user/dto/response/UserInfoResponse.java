package ssu.groupstudy.domain.user.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.domain.User;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class UserInfoResponse {
    private Long userId;
    private String nickname;
    private String statusMessage;
    private String profileImage;

    public UserInfoResponse(User user){
        this.userId = user.getUserId();
        this.nickname = user.getNickname();
        this.statusMessage = user.getStatusMessage();
        this.profileImage = user.getPicture();
    }

    public static UserInfoResponse from(User user) {
        return new UserInfoResponse(user);
    }
}