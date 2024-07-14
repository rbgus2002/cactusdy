package ssu.groupstudy.domain.user.param;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import ssu.groupstudy.domain.user.entity.UserEntity;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class UserParam {
    private Long userId;
    private String name;
    private String nickname;
    private String statusMessage;
    private String phoneNumber;
    private String profileImage;

    public static UserParam from(UserEntity user) {
        return new UserParam(
                user.getUserId(),
                user.getName(),
                user.getNickname(),
                user.getStatusMessage(),
                user.getPhoneNumber(),
                user.getPicture()
        );
    }
}
