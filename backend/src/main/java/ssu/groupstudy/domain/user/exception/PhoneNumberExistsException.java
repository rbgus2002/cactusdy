package ssu.groupstudy.domain.user.exception;

import ssu.groupstudy.domain.common.exception.BusinessException;
import ssu.groupstudy.domain.common.enums.ResultCode;

public class PhoneNumberExistsException extends BusinessException {
    public PhoneNumberExistsException(ResultCode resultCode){
        super(resultCode);
    }
}
