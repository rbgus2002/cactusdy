package ssu.groupstudy.global.handler;

import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import ssu.groupstudy.global.ResultCode;
import ssu.groupstudy.global.dto.ErrorResponseDto;
import ssu.groupstudy.global.exception.BusinessException;

import javax.validation.UnexpectedTypeException;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ErrorResponseDto> handleHttpMessageNotReadableException(HttpMessageNotReadableException e) {
        // TODO : Error message 안찍히는 에러 수정
        log.error("handleHttpMessageNotReadableException : {}", e);
        final ErrorResponseDto response = ErrorResponseDto.of(ResultCode.INVALID_JSON);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }


    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponseDto> handleMethodArgumentNotValidException(MethodArgumentNotValidException e) {
        log.error("handleMethodArgumentNotValidException : {}", e);
        final ErrorResponseDto response = ErrorResponseDto.of(ResultCode.INVALID_METHOD_ARGUMENT);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }

    @ExceptionHandler(UnexpectedTypeException.class)
    public ResponseEntity<ErrorResponseDto> handleUnexpectedTypeException(UnexpectedTypeException e) {
        log.error("handleUnexpectedTypeException : {}", e);
        final ErrorResponseDto response = ErrorResponseDto.of(ResultCode.INVALID_METHOD_ARGUMENT);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ErrorResponseDto> handleDataIntegrityViolationException(DataIntegrityViolationException e) {
        log.error("handleDataIntegrityViolationException : {}", e);
        final ErrorResponseDto response = ErrorResponseDto.of(ResultCode.NOT_SATISFIED_DB_CONSTRAINT);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    protected ResponseEntity<ErrorResponseDto> handleHttpRequestMethodNotSupportedException(HttpRequestMethodNotSupportedException e) {
        log.error("handleHttpRequestMethodNotSupportedException", e);
        final ErrorResponseDto response = ErrorResponseDto.of(ResultCode.METHOD_NOT_ALLOWED);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ErrorResponseDto> handleBusinessException(BusinessException e) {
        log.warn("BusinessException : {}", e.getMessage());
        final ErrorResponseDto response = ErrorResponseDto.of(e.getResultCode());
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }

    @ExceptionHandler(Exception.class)
    protected ResponseEntity<ErrorResponseDto> handleException(Exception e) {
        log.error("handleException", e);
        final ErrorResponseDto response = ErrorResponseDto.of(ResultCode.INTERNAL_SERVER_ERROR);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }
}
