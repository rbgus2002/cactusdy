package ssu.groupstudy.domain.round.domain;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Where;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.global.domain.BaseEntity;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
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
    // TODO : place랑 time을 Appointment로 묶기
    // TODO : 스터디 예정 시간 계산 하는 로직은 해당 객체에게 책임 부여하기

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="studyId", nullable = false)
    private Study study;

    @Column(nullable = false)
    private char deleteYn;

    @Builder
    public Round(Study study, String studyPlace, LocalDateTime studyTime){
        this.study = study;
        this.studyPlace = studyPlace;
        this.studyTime = studyTime;
    }
}