package ssu.groupstudy.domain.round.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.domain.Study;

import java.time.LocalDateTime;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Round {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long roundId;

    @Column(length = 50)
    private String detail;

    @Column(nullable = false, length = 30)
    private String studyPlace;

    @Column(nullable = false)
    private LocalDateTime studyTime;

    @ManyToOne
    @JoinColumn(name="studyId", nullable = false)
    private Study study;

    @Column(nullable = false)
    private char deleteYn;
}