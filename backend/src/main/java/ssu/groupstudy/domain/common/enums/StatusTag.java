package ssu.groupstudy.domain.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum StatusTag {
    ATTENDANCE("출석"),
    LATE("지각"),
    ABSENT("결석"),
    ;

    private final String detail;
}
