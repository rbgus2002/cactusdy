package ssu.groupstudy.domain.user.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.domain.User;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class UserResponse {
    private Long userId;
    private String nickName;
    private String statusMessage;

    public UserResponse(User user){
        this.userId = user.getUserId();
        this.nickName = user.getNickName();
        this.statusMessage = user.getStatusMessage();
    }

    public static UserResponse from(User user){
        return new UserResponse(user);
    }
}
