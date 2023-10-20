package ssu.groupstudy.global.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum S3Code {
    USER_IMAGE("groupstudy-user-profile-", "[groupstudy-image-bucket] 사용자 프로필 이미지"),
    STUDY_IMAGE("groupstudy-study-profile-", "[groupstudy-image-bucket] 스터디 이미지"),
    ;

    private final String prefix;
    private final String description;
}
