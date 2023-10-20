package ssu.groupstudy.global.dto;

import lombok.Getter;
import ssu.groupstudy.global.constant.ResultCode;

import java.util.HashMap;
import java.util.Map;

@Getter
public class DataResponseDto<T> extends ResponseDto {
    private final Map<String, T> data;

    private DataResponseDto(String key, T data) {
        super(true, ResultCode.OK.getStatusCode(), ResultCode.OK.getMessage());
        this.data = stringToMap(key, data);
    }

    public static <T> DataResponseDto<T> of(String key, T data) {
        return new DataResponseDto<>(key, data);
    }

    private Map<String, T> stringToMap(String key, T data) {
        Map<String, T> map = new HashMap<>();
        map.put(key, data);
        return map;
    }
}
