package ssu.groupstudy.domain.user.dto.request;

import lombok.*;
import ssu.groupstudy.domain.user.entity.UserEntity;

import javax.validation.constraints.NotBlank;

@Getter
@AllArgsConstructor
@Builder
@NoArgsConstructor(access = AccessLevel.PRIVATE)
@ToString
public class SignUpRequest {
    @NotBlank(message = "이름을 입력하세요")
    private String name;
    @NotBlank(message = "닉네임을 입력하세요")
    private String nickname;
    @NotBlank(message = "휴대폰번호를 입력하세요")
    private String phoneNumber;
    @NotBlank(message = "비밀번호를 입력하세요")
    private String password;

    public UserEntity toEntity(String password){
        return UserEntity.builder()
                .name(this.name)
                .nickname(this.nickname)
                .phoneNumber(this.phoneNumber)
                .password(password)
                .build();
    }
}
