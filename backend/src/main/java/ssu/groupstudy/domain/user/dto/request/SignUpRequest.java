package ssu.groupstudy.domain.user.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.*;
import ssu.groupstudy.domain.user.domain.User;

@Getter
@AllArgsConstructor
@Builder
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class SignUpRequest {
    @NotBlank(message = "이름을 입력하세요")
    String name;
    @NotBlank(message = "닉네임을 입력하세요")
    String nickName;
    String phoneModel;
    String picture;
    @Email(message = "이메일 형식이 아닙니다")
    @NotBlank(message = "이메일을 입력하세요")
    String email;

    public User toEntity(){
        return User.builder()
                .name(this.name)
                .nickName(this.nickName)
                .phoneModel(this.phoneModel)
                .picture(this.picture)
                .email(this.email)
                .build();
    }
}
