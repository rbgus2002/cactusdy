package ssu.groupstudy.domain.study.domain;

import lombok.AccessLevel;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class StudyColorKey implements Serializable {
    // userId, studyId 복합키를 PK로 설정
    private Long user;
    private Long study;
}
