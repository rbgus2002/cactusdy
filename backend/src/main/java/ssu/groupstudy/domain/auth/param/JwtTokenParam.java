package ssu.groupstudy.domain.auth.param;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor(staticName = "of")
public class JwtTokenParam {
    private Long userId;
    private String jwtToken;
}
