package ssu.groupstudy.domain.auth.dto.request;

import lombok.Getter;

import javax.validation.constraints.Pattern;

@Getter
public class PasswordResetRequest {
    @Pattern(regexp = "^010\\d{8}$", message = "올바른 휴대폰 번호를 입력해주세요")
    private String phoneNumber;
    private String newPassword;
}
