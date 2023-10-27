package ssu.groupstudy.global.dto;

import lombok.Getter;
import ssu.groupstudy.global.constant.ResultCode;

@Getter
public class ErrorResponseDto extends ResponseDto{
    private ErrorResponseDto(ResultCode resultCode){
        super(false, resultCode.getStatusCode(), resultCode.getMessage());
    }

    private ErrorResponseDto(ResultCode resultCode, String message){
        super(false, resultCode.getStatusCode(), message);
    }

    public static ErrorResponseDto of(ResultCode resultCode){
        return new ErrorResponseDto(resultCode);
    }

    public static ErrorResponseDto of(ResultCode resultCode, String message){
        return new ErrorResponseDto(resultCode, message);
    }
}
