package ssu.groupstudy.api.user.vo;

import lombok.Getter;
import lombok.ToString;

import javax.validation.constraints.Pattern;

@Getter
@ToString
public class PasswordResetReqVo {
    @Pattern(regexp = "^010\\d{8}$", message = "올바른 휴대폰 번호를 입력해주세요")
    private String phoneNumber;
    private String newPassword;
}
