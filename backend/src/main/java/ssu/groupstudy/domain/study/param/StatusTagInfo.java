package ssu.groupstudy.domain.study.param;

import lombok.Getter;
import lombok.ToString;
import ssu.groupstudy.domain.common.enums.StatusTag;

@Getter
@ToString
public class StatusTagInfo { // [2024-06-10:최규현] TODO: param 계층으로 분리
    private final StatusTag statusTag;
    private final Long count;

    public StatusTagInfo(StatusTag statusTag, Long count) {
        this.statusTag = statusTag;
        this.count = count;
    }
}
