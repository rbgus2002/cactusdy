package ssu.groupstudy.domain.study.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.domain.User;


@Entity
@Table(name = "REL_User_Study")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
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
