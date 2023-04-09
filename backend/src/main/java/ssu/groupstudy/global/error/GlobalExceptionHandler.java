package ssu.groupstudy.global.error;

import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    //MissingServletRequestParameterException.class,

//    @ExceptionHandler({ Exception.class})
//    protected ResponseEntity handleCustomException(CustomException ex) {
//        return new ResponseEntity(new ErrorDto(ex.getErrorCode().getStatus(), ex.getErrorCode().getMessage()), HttpStatus.valueOf(ex.getErrorCode().getStatus()));
//    }
}
