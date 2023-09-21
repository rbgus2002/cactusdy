package ssu.groupstudy.domain.user.dto.request;

import lombok.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import ssu.groupstudy.domain.user.domain.User;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;

@Getter
@AllArgsConstructor
@Builder
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class SignUpRequest {
    @NotBlank(message = "이름을 입력하세요")
    private String name;
    @NotBlank(message = "닉네임을 입력하세요")
    private String nickname;
    private String phoneModel;
    private String picture;
    @Email(message = "이메일 형식이 아닙니다")
    @NotBlank(message = "이메일을 입력하세요")
    private String email;

    @NotBlank(message = "비밀번호를 입력하세요")
    private String password;

    public User toEntity(PasswordEncoder passwordEncoder){
        return User.builder()
                .name(this.name)
                .nickname(this.nickname)
                .phoneModel(this.phoneModel)
                .picture(this.picture)
                .email(this.email)
                .password(passwordEncoder.encode(this.password))
                .build();
    }
}
