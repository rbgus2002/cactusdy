package ssu.groupstudy.global.dto;

import lombok.Getter;
import ssu.groupstudy.global.ResultCode;

import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

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
        return Stream.of(Map.entry(key, data))
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
    }
}
