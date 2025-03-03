package ssu.groupstudy.api.common.vo;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class IdResVo {
    private Long id;

    public static IdResVo of(Long id) {
        return new IdResVo(id);
    }
}
