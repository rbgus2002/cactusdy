package ssu.groupstudy.domain.user.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.entity.UserEntity;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class SignInResponse {
    private Long userId;
    private String token;

    private SignInResponse(Long userId, String token) {
        this.userId = userId;
        this.token = token;
    }

    public static SignInResponse of(UserEntity user, String token){
        return new SignInResponse(user.getUserId(), token);
    }
}
