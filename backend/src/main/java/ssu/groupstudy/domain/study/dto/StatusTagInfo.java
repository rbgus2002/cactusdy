package ssu.groupstudy.domain.study.dto;

import lombok.Getter;
import lombok.ToString;
import ssu.groupstudy.domain.common.enums.StatusTag;

@Getter
@ToString
public class StatusTagInfo {
    private final StatusTag statusTag;
    private final Long count;

    public StatusTagInfo(StatusTag statusTag, Long count) {
        this.statusTag = statusTag;
        this.count = count;
    }
}
