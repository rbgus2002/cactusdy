package ssu.groupstudy.domain.user.exception;

import ssu.groupstudy.global.exception.BusinessException;
import ssu.groupstudy.global.error.ErrorCode;

public class EmailExistsException extends BusinessException {
    public EmailExistsException(ErrorCode errorCode){
        super(errorCode);
    }
}
