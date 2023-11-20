package ssu.groupstudy.domain.study.dto;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class ParticipantInfo {
    private String name;
    private String color;
    private String studyProfileImage;

    public ParticipantInfo(String name, String color, String studyProfileImage) {
        this.name = name;
        this.color = color;
        this.studyProfileImage = studyProfileImage;
    }
}
