package ssu.groupstudy.domain.task.domain;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.round.exception.InvalidRoundParticipantException;

import javax.persistence.*;

import static javax.persistence.FetchType.EAGER;
import static ssu.groupstudy.global.ResultCode.INVALID_TASK_DELETION;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
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

    @ManyToOne(fetch = EAGER) // TODO : EAGER로 하지 않으면 equals&hash 안먹음
    @JoinColumn(name="user_round_id", nullable = false)
    private RoundParticipant roundParticipant;

    @Builder // TODO : TEST 용으로 만든건데 괜찮을지 고민해보기
    public Task(String detail, TaskType taskType, RoundParticipant roundParticipant) {
        this.detail = detail;
        this.taskType = taskType;
        this.doneYn = 'N';
        this.roundParticipant = roundParticipant;
    }

    public void validateDelete(RoundParticipant roundParticipant){
        if(!roundParticipant.equals(this.roundParticipant)){
            throw new InvalidRoundParticipantException(INVALID_TASK_DELETION);
        }
    }
}