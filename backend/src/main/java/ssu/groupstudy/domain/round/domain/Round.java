package ssu.groupstudy.domain.round.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Where;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.global.domain.BaseEntity;

import java.time.LocalDateTime;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Where(clause = "delete_yn = 'N'")
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

    // TODO : 스터디 예정 시간 계산 하는 로직은 해당 객체에게 책임 부여하기
}