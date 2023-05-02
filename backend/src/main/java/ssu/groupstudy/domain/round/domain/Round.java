package ssu.groupstudy.domain.round.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.global.domain.BaseEntity;

import java.time.LocalDateTime;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Round extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long roundId;

    @Column(length = 50)
    private String detail;

    @Column(length = 30)
    private String studyPlace;

    @Column
    private LocalDateTime studyTime;

    @ManyToOne
    @JoinColumn(name="studyId", nullable = false)
    private Study study;

    // TODO : OneToMany 학습 후 적용

    @Column(nullable = false)
    private char deleteYn;
}