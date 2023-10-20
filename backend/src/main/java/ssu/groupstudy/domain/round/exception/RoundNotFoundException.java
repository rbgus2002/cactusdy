package ssu.groupstudy.domain.round.exception;

import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class RoundNotFoundException extends BusinessException {
    public RoundNotFoundException(ResultCode resultCode){
        super(resultCode);
    }
}
