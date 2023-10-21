package ssu.groupstudy.global.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum S3Code {
    USER_IMAGE("profile/user/", "[사용자 프로필 이미지] prefix + userId"),
    STUDY_IMAGE("profile/study/", "[스터디 이미지] prefix + studyId"),
    ;

    private final String prefix;
    private final String description;
}
