package ssu.groupstudy.Entity;

import jakarta.persistence.*;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@NoArgsConstructor
public class Task {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long taskId;

    @Column(nullable = false, length = 30)
    private String detail;

    //TODO ENUM 처리
    @Column(nullable = false)
    private String taskType;

    @Column(nullable = false)
    private char doneYn;

    @Column(nullable = false)
    private char deleteYn;

    @Column(nullable = false)
    private LocalDateTime createTime;

    @ManyToOne
    @JoinColumn(name="userRoundId", nullable = false)
    private UserRound userRound;
}