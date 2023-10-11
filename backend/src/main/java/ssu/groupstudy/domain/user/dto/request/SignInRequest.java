package ssu.groupstudy.domain.user.dto.request;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class SignInRequest {
    @NotBlank(message = "휴대폰번호를 입력하세요")
    private String phoneNumber;

    @NotBlank(message = "비밀번호를 입력하세요")
    private String password;
}
