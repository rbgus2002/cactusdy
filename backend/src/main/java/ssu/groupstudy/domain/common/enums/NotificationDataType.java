package ssu.groupstudy.domain.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum NotificationDataType {
    NOTICE("notice"),
    ROUND("round"),
    ;

    private final String value;
}
