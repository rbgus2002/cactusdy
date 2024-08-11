package ssu.groupstudy.domain.task.entity;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.common.entity.BaseEntity;
import ssu.groupstudy.domain.common.enums.TaskType;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.domain.round.exception.InvalidRoundParticipantException;
import ssu.groupstudy.domain.study.entity.StudyEntity;

import javax.persistence.*;

import static javax.persistence.FetchType.LAZY;
import static ssu.groupstudy.domain.common.enums.ResultCode.INVALID_TASK_ACCESS;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "task")
@Getter
public class TaskEntity extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "task_id")
    private Long id;

    @Column(nullable = false, length = 255)
    private String detail;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private TaskType taskType;

    @Column(nullable = false)
//    @Convert(converter = YNBooleanConverter.class) // [2024-06-10:최규현] TODO: 적용하면서 api spec 변경 필요
    private char doneYn;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "user_round_id", nullable = false)
    private RoundParticipantEntity roundParticipant;

    @Builder
    public TaskEntity(String detail, TaskType taskType, RoundParticipantEntity roundParticipant) {
        this.detail = detail;
        this.taskType = taskType;
        this.doneYn = 'N';
        this.roundParticipant = roundParticipant;
    }

    public static TaskEntity of(String detail, TaskType type, RoundParticipantEntity roundParticipant) {
        return TaskEntity.builder()
                .detail(detail)
                .taskType(type)
                .roundParticipant(roundParticipant)
                .build();
    }

    public void validateAccess(RoundParticipantEntity roundParticipant) {
        if (!this.roundParticipant.equals(roundParticipant)) {
            throw new InvalidRoundParticipantException(INVALID_TASK_ACCESS);
        }
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

    public char switchDoneYn() {
        return (doneYn == 'N') ? checkTask() : uncheckTask();
    }

    private char checkTask() {
        doneYn = 'Y';
        return doneYn;
    }

    private char uncheckTask() {
        doneYn = 'N';
        return doneYn;
    }

    public boolean isDone() {
        return doneYn == 'Y';
    }

    public StudyEntity getStudy() {
        return getRoundParticipant().getRound().getStudy();
    }
}