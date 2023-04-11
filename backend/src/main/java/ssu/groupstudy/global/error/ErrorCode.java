package ssu.groupstudy.global.error;

import lombok.AllArgsConstructor;
import lombok.Getter;

// TODO : ErrorCode 생성, SuccessCode도 만드는 편이 좋겠다.
@AllArgsConstructor
@Getter
public enum ErrorCode {

    EMAIL_EXISTS_ALREADY("이미 존재하는 이메일입니다."),
            ;

    private final String message;
}