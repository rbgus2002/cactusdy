package ssu.groupstudy.domain.study.exception;

import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class StudyNotFoundException  extends BusinessException {
    public StudyNotFoundException(ResultCode resultCode){
        super(resultCode);
    }
}
