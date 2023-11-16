package ssu.groupstudy.domain.study.dto;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class StudyColorInfo {
    private String name;
    private String color;

    public StudyColorInfo(String name, String color) {
        this.name = name;
        this.color = color;
    }
}
