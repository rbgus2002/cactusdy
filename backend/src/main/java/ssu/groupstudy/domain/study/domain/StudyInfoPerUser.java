package ssu.groupstudy.domain.study.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.domain.User;


@Entity
@Table(name = "REL_User_Study")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
public class StudyInfoPerUser {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name="userId", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name="studyId", nullable = false)
    private Study study;

    @Column(nullable = false)
    private String color;

    @Column(nullable = false)
    private char isBanished;

    @Builder
    public StudyInfoPerUser(User user, Study study) {
        this.user = user;
        this.study = study;
        this.color = ""; // TODO : 색상 입력 구현 (color picker?)
        this.isBanished = 'N';
    }
}
