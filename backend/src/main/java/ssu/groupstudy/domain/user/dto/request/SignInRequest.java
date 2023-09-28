package ssu.groupstudy.domain.user.dto.request;

import lombok.*;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class SignInRequest {
    @Email(message = "이메일 형식이 아닙니다")
    @NotBlank(message = "이메일을 입력하세요")
    private String email;

    @NotBlank(message = "비밀번호를 입력하세요")
    private String password;
}
