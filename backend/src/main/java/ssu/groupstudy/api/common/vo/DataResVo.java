package ssu.groupstudy.api.common.vo;

import lombok.Getter;
import ssu.groupstudy.domain.common.enums.ResultCode;

import java.util.HashMap;
import java.util.Map;

@Getter
public class DataResVo<T> extends ResVo {
    private final Map<String, T> data;

    private DataResVo(String key, T data) {
        super(true, ResultCode.OK.getStatusCode(), ResultCode.OK.getMessage());
        this.data = stringToMap(key, data);
    }

    public static <T> DataResVo<T> of(String key, T data) {
        return new DataResVo<>(key, data);
    }

    private Map<String, T> stringToMap(String key, T data) {
        Map<String, T> map = new HashMap<>();
        map.put(key, data);
        return map;
    }
}
