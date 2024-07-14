package ssu.groupstudy.api.user.vo;

import lombok.Getter;
import lombok.ToString;

import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

@Getter
@ToString
public class UserSignUpVerifyReqVo {
    @Pattern(regexp = "^010\\d{8}$", message = "올바른 휴대폰 번호를 입력해주세요")
    private String phoneNumber;

    @Size(min = 6, max = 6, message = "인증번호는 6자리를 입력해야합니다")
    private String code;
}
