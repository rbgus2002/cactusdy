package ssu.groupstudy.domain.study.param;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class ParticipantInfo { // [2024-06-10:최규현] TODO: param 계층으로 분리
    private String name;
    private String color;
    private String studyProfileImage;

    public ParticipantInfo(String name, String color, String studyProfileImage) {
        this.name = name;
        this.color = color;
        this.studyProfileImage = studyProfileImage;
    }
}
