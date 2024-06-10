package ssu.groupstudy.api.common.vo;

import lombok.Getter;
import ssu.groupstudy.domain.common.enums.ResultCode;

@Getter
public class ErrorResVo extends ResVo {
    private ErrorResVo(ResultCode resultCode){
        super(false, resultCode.getStatusCode(), resultCode.getMessage());
    }

    private ErrorResVo(ResultCode resultCode, String message){
        super(false, resultCode.getStatusCode(), message);
    }

    public static ErrorResVo of(ResultCode resultCode){
        return new ErrorResVo(resultCode);
    }

    public static ErrorResVo of(ResultCode resultCode, String message){
        return new ErrorResVo(resultCode, message);
    }
}
