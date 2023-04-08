package ssu.groupstudy.Entity.Key;

import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Data;
import lombok.NoArgsConstructor;
import ssu.groupstudy.Entity.Round;
import ssu.groupstudy.Entity.User;

import java.io.Serializable;

@Data
@NoArgsConstructor
public class StudyColorKey implements Serializable {
    // userId, studyId 복합키를 PK로 설정
    private Long user;
    private Long study;
}
