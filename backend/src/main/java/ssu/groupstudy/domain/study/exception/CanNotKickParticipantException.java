package ssu.groupstudy.domain.study.exception;

import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class CanNotKickParticipantException extends BusinessException {
    public CanNotKickParticipantException(ResultCode resultCode, String message) {
        super(resultCode, message);
    }

    public CanNotKickParticipantException(ResultCode resultCode) {
        super(resultCode);
    }
}
