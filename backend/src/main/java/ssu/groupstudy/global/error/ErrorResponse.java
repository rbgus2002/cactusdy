package ssu.groupstudy.global.error;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class ErrorResponse {
    private final int statusCode;
    private final String message;

    public static ErrorResponse of(int statusCode, String message){
        return new ErrorResponse(statusCode, message);
    }
}
