package ssu.groupstudy.domain.user.exception;

// TODO : Business Exception 상속받을 수 있는 지 여부 확인하고 좀 더 낮은 단계의 클래스 상속하면 좋을 거 같음
public class EmailExistsException extends RuntimeException{
    public EmailExistsException(String message){
        super(message);
    }
}
