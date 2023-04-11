package ssu.groupstudy.global.error;

import lombok.AllArgsConstructor;
import lombok.Getter;

// TODO : Success Code 필요 여부 생각
@AllArgsConstructor
@Getter
public enum ErrorCode {

    DUPLICATE_EMAIL_ERROR(400, "이미 존재하는 이메일입니다."),
    INVALID_METHOD_ARGUMENT_ERROR(400, "잘못된 인자입니다."),
    NULL_VALUE_ERROR(400, "Null 값이 올 수 없습니다.")

            ;

    int statusCode;
    private final String message;
}