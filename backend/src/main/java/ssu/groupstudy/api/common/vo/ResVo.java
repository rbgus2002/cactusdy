package ssu.groupstudy.api.common.vo;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import ssu.groupstudy.domain.common.enums.ResultCode;

@Getter
@AllArgsConstructor(access = AccessLevel.PROTECTED)
public class ResVo {
    private final Boolean success;
    private final Integer statusCode;
    private final String message;

    public static ResVo of(Boolean success, ResultCode resultCode){
        return new ResVo(success, resultCode.getStatusCode(), resultCode.getMessage());
    }

    public static ResVo success(){
        return new ResVo(true, ResultCode.OK.getStatusCode(), ResultCode.OK.getMessage());
    }

    @Override
    public String toString() {
        return "{\n" +
                "  \"success\": " + success +
                ",\n  \"statusCode\": " + statusCode +
                ",\n  \"message\": \"" + message + "\"" +
                "\n}";
    }
}