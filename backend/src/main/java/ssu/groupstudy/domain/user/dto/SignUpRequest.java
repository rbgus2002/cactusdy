package ssu.groupstudy.domain.user.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.domain.User;

@Getter
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class SignUpRequest {
    // TODO : message도 ErrorCode에 추가해서 enum 활용하기
    @NotBlank(message = "이름은 Null일 수 없습니다.")
    String name;
    @NotBlank
    String nickName;
    String phoneModel;
    String picture;
    @Email
    @NotBlank
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
