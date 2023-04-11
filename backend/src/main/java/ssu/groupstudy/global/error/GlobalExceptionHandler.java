package ssu.groupstudy.global.error;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import ssu.groupstudy.domain.user.exception.EmailExistsException;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    //MissingServletRequestParameterException.class,

//    @ExceptionHandler({ Exception.class})
//    protected ResponseEntity handleCustomException(CustomException ex) {
//        return new ResponseEntity(new ErrorDto(ex.getErrorCode().getStatus(), ex.getErrorCode().getMessage()), HttpStatus.valueOf(ex.getErrorCode().getStatus()));
//    }

    // TODO : return 형식 수정 및 ResponseEntity 컨트롤러에서 어떻게 처리할 지 고민
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Object handleMethodArgumentNotValidException(MethodArgumentNotValidException e) {
        String errorMessage = e.getBindingResult()
                .getAllErrors()
                .get(0)
                .getDefaultMessage();

//        printExceptionMessage(errorMessage);
        log.error("handleMethodArgumentNotValidException : {}", errorMessage);
        return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(EmailExistsException.class)
    public ResponseEntity<String> handleEmailExistsException(EmailExistsException e) {
        String errorMessage = e.getMessage();
        ;
        log.error("handleEmailExistsException : {}", errorMessage);
        return new ResponseEntity<>(errorMessage,null ,HttpStatus.BAD_REQUEST);
    }
}
