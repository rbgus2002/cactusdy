package ssu.groupstudy.domain.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum TaskType {
    GROUP("그룹 과제"),
    PERSONAL("개인 과제"),
    ;

    private final String detail;

    public boolean isGroupType(){
        return this == GROUP;
    }

    public boolean isPersonalType(){
        return this == PERSONAL;
    }
}

