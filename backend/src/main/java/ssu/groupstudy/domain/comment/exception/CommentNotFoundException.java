package ssu.groupstudy.domain.comment.exception;

import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.common.exception.BusinessException;

public class CommentNotFoundException extends BusinessException {
    public CommentNotFoundException(ResultCode resultCode) {
        super(resultCode);
    }
}
