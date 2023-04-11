package ssu.groupstudy.global.error;

import lombok.AllArgsConstructor;
import lombok.Getter;

// TODO : Success Code 필요 여부 생각
@AllArgsConstructor
@Getter
public enum ErrorCode {

    // 400
    DUPLICATE_EMAIL_ERROR(400, "이미 존재하는 이메일입니다."),
    INVALID_METHOD_ARGUMENT_ERROR(400, "잘못된 인자입니다."),
    NULL_VALUE_ERROR(400, "Null 값이 올 수 없습니다."),

    // 405
    METHOD_NOT_ALLOWED(405, "대상 리소스가 이 메서드를 지원하지 않습니다."),

    // 500
    INTERNAL_SERVER_ERROR(500, "서버에서 문제가 발생했습니다."),


            ;

    int statusCode;
    private final String message;
}