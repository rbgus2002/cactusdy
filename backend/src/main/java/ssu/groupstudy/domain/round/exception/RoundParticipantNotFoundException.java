package ssu.groupstudy.domain.round.exception;

import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class RoundParticipantNotFoundException extends BusinessException {
    public RoundParticipantNotFoundException(ResultCode resultCode, String message) {
        super(resultCode, message);
    }

    public RoundParticipantNotFoundException(ResultCode resultCode) {
        super(resultCode);
    }
}
