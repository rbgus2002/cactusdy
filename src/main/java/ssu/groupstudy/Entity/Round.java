package ssu.groupstudy.Entity;

import jakarta.persistence.*;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@NoArgsConstructor
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