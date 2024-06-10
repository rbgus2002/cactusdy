package ssu.groupstudy.domain.rule.exception;

import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class RuleNotFoundException extends BusinessException {
    public RuleNotFoundException(ResultCode resultCode, String message) {
        super(resultCode, message);
    }

    public RuleNotFoundException(ResultCode resultCode) {
        super(resultCode);
    }
}
