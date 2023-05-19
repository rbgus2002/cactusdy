package ssu.groupstudy.domain.study.domain;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.domain.User;

import javax.persistence.*;
import java.util.Objects;


@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "rel_user_study")
@Getter
public class Participant {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "userId", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "studyId", nullable = false)
    private Study study;

    @Column(nullable = false)
    private String color;

    @Column(nullable = false)
    private char banishYn;

    @Builder
    public Participant(User user, Study study) {
        this.user = user;
        this.study = study;
        this.color = generateColor(); // TODO : 색상 입력 구현 (color picker?)
        this.banishYn = 'N';
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;

        final Participant participant = (Participant) o;
        return Objects.equals(user.getUserId(), participant.user.getUserId()) && Objects.equals(study.getStudyId(), participant.study.getStudyId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(user.getUserId(), study.getStudyId());
    }

    // TODO : 초기에 색상 자동 결정 (초기에 선택 불가)
    private String generateColor() {
        return "";
    }

    public boolean isBanished() {
        return (banishYn == 'Y');
    }
}
