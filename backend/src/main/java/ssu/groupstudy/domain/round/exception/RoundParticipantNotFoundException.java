package ssu.groupstudy.domain.round.exception;

import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.common.exception.BusinessException;

public class RoundParticipantNotFoundException extends BusinessException {
    public RoundParticipantNotFoundException(ResultCode resultCode, String message) {
        super(resultCode, message);
    }

    public RoundParticipantNotFoundException(ResultCode resultCode) {
        super(resultCode);
    }
}
