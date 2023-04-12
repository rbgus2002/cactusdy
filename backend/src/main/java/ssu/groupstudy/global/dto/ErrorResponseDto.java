package ssu.groupstudy.global.dto;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.global.error.ErrorCode;

@Getter
public class ErrorResponseDto extends ResponseDto{
    private ErrorResponseDto(ErrorCode errorCode){
        super(false, errorCode.getStatusCode(), errorCode.getMessage());
    }

    public static ErrorResponseDto of(ErrorCode errorCode){
        return new ErrorResponseDto(errorCode);
    }
}
