package ssu.groupstudy.domain.task.domain;

import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.round.domain.RoundParticipant;

import javax.persistence.*;

import static javax.persistence.FetchType.LAZY;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Task{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long taskId;

    @Column(nullable = false, length = 30)
    private String detail;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private TaskType taskType;

    @Column(nullable = false)
    private char doneYn;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name="user_round_id", nullable = false)
    private RoundParticipant roundParticipant;
}