package ssu.groupstudy.domain.auth.dto;

import lombok.Getter;

import javax.validation.constraints.Pattern;

@Getter
public class MessageRequest {
    @Pattern(regexp = "^010\\d{8}$", message = "올바른 휴대폰 번호를 입력해주세요")
    private String phoneNumber;
}
