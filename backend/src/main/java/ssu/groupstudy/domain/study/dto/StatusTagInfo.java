package ssu.groupstudy.domain.study.dto;

import lombok.Getter;
import ssu.groupstudy.domain.round.domain.StatusTag;

@Getter
public class StatusTagInfo {
    private final StatusTag statusTag;
    private final Long count;

    public StatusTagInfo(StatusTag statusTag, Long count) {
        this.statusTag = statusTag;
        this.count = count;
    }

    @Override
    public String toString() {
        return "StatusTagInfo{" +
                "statusTag=" + statusTag +
                ", count=" + count +
                '}';
    }
}
