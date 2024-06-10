package ssu.groupstudy.api.user.vo;

import lombok.*;

import javax.validation.constraints.NotBlank;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@Builder
@ToString
public class SignInReqVo {
    @NotBlank(message = "휴대폰번호를 입력하세요")
    private String phoneNumber;

    @NotBlank(message = "비밀번호를 입력하세요")
    private String password;

    @NotBlank(message = "FCM 토큰을 입력하세요")
    private String fcmToken;
}
