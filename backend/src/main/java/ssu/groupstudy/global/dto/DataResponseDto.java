package ssu.groupstudy.global.dto;

import lombok.Getter;
import ssu.groupstudy.global.ResultCode;

import java.util.HashMap;
import java.util.Map;

@Getter
public class DataResponseDto<T> extends ResponseDto {
    private final Map data;

    private DataResponseDto(String key, T data) {
        super(true, ResultCode.OK.getStatusCode(), ResultCode.OK.getMessage());
        this.data = stringToMap(key, data);
    }

    public static <T> DataResponseDto<T> of(String key, T data) {
        return new DataResponseDto<>(key, data);
    }

    // TODO : stream 사용해서 한 줄로 리턴하도록 수정
    private Map<String, T> stringToMap(String key, T data) {
        Map map = new HashMap();
        map.put(key, data);
        return map;
    }
}
