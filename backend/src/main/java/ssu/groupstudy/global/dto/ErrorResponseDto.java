package ssu.groupstudy.global.dto;

import lombok.Getter;
import ssu.groupstudy.global.ResultCode;

@Getter
public class ErrorResponseDto extends ResponseDto{
    private ErrorResponseDto(ResultCode resultCode){
        super(false, resultCode.getStatusCode(), resultCode.getMessage());
    }

    public static ErrorResponseDto of(ResultCode resultCode){
        return new ErrorResponseDto(resultCode);
    }
}
