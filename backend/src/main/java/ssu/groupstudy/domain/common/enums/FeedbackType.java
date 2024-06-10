package ssu.groupstudy.domain.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum FeedbackType {
    BUG("버그 제보"),
    FEAT("신규 기능"),
    ENHANCE("기능 개선"),
    ETC("기타"),
    ;

    private final String description;
}
