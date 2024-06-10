package ssu.groupstudy.domain.round.exception;

import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.common.exception.BusinessException;

public class RoundNotFoundException extends BusinessException {
    public RoundNotFoundException(ResultCode resultCode){
        super(resultCode);
    }
}
