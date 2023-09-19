package ssu.groupstudy.domain.round.exception;

import ssu.groupstudy.global.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class UnauthorizedDeletionException extends BusinessException {
    public UnauthorizedDeletionException(ResultCode resultCode, String message) {
        super(resultCode, message);
    }

    public UnauthorizedDeletionException(ResultCode resultCode) {
        super(resultCode);
    }
}
