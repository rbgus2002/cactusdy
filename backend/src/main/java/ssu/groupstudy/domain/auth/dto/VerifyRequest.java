package ssu.groupstudy.domain.auth.dto;

import lombok.Getter;

import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

@Getter
public class VerifyRequest {
    @Pattern(regexp = "^010\\d{8}$", message = "올바른 휴대폰 번호를 입력해주세요")
    private String phoneNumber;

    @Size(min = 6, max = 6, message = "인증번호는 6자리를 입력해야합니다")
    private String code;
}
