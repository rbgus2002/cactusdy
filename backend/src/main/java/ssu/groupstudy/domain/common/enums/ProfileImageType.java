package ssu.groupstudy.domain.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum ProfileImageType {
    USER_IMAGE("profile/user/%d/%s"),
    STUDY_IMAGE("profile/study/%d/%s"),
    ;

    private final String keyFormat;
}
