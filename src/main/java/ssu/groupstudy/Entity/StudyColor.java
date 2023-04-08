package ssu.groupstudy.Entity;

import jakarta.persistence.*;
import lombok.NoArgsConstructor;
import ssu.groupstudy.Entity.Key.StudyColorKey;


@Entity
@Table(name = "REL_User_Study")
@NoArgsConstructor
@IdClass(StudyColorKey.class)
public class StudyColor {
    @Id
    @ManyToOne
    @JoinColumn(name="userId", nullable = false)
    private User user;

    @Id
    @ManyToOne
    @JoinColumn(name="studyId", nullable = false)
    private Study study;

    @Column(nullable = false)
    private String color;
}
