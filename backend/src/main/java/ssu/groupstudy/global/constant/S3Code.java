package ssu.groupstudy.global.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum S3Code {
    USER_IMAGE("profile/user/%d/%s", "[사용자 프로필 이미지] userId, UUID"),
    STUDY_IMAGE("profile/study/%d/%s", "[스터디 프로필 이미지] userId, UUID"),
    ;

    private final String format;
    private final String description;
}
