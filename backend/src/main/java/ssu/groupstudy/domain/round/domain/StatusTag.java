package ssu.groupstudy.domain.round.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum StatusTag {

    NONE("미정"),
    ATTENDANCE("출석"),
    ATTENDANCE_EXPECTED("출석예정"),
    LATE("지각"),
    ABSENT("결석"),
    NONE_ATTENDANCE("결석"),
    ;

    private final String detail;
}
