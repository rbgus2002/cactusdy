package ssu.groupstudy.global.dto;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import ssu.groupstudy.global.error.ErrorCode;

@Getter
@AllArgsConstructor(access = AccessLevel.PROTECTED)
public class ResponseDto {
    private final Boolean success;
    private final Integer statusCode;
    private final String message;

    public static ResponseDto of(Boolean success, ErrorCode errorCode){
        return new ResponseDto(success, errorCode.getStatusCode(), errorCode.getMessage());
    }
}
