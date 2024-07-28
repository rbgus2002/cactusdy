package ssu.groupstudy.api.user.vo;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.auth.param.JwtTokenParam;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class SignInResVo {
    private Long userId;
    private String token;

    private SignInResVo(Long userId, String token) {
        this.userId = userId;
        this.token = token;
    }

    public static SignInResVo of(JwtTokenParam jwtTokenParam) {
        return new SignInResVo(jwtTokenParam.getUserId(), jwtTokenParam.getJwtToken());
    }
}
