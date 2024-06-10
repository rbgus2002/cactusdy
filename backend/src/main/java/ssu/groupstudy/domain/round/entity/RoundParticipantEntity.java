package ssu.groupstudy.domain.round.entity;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.common.enums.StatusTag;
import ssu.groupstudy.domain.task.entity.TaskEntity;
import ssu.groupstudy.domain.common.enums.TaskType;
import ssu.groupstudy.domain.user.entity.UserEntity;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

import static javax.persistence.CascadeType.ALL;
import static javax.persistence.FetchType.LAZY;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Table(name = "rel_user_round")
public class RoundParticipantEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_round_id")
    private Long id;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "userId", nullable = false)
    private UserEntity user;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "roundId", nullable = false)
    private RoundEntity round;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private StatusTag statusTag;

    @OneToMany(mappedBy = "roundParticipant", cascade = ALL, orphanRemoval = true)
    private final Set<TaskEntity> tasks = new HashSet<>();

    public RoundParticipantEntity(UserEntity user, RoundEntity round) {
        this.user = user;
        this.round = round;
        this.statusTag = StatusTag.ATTENDANCE;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof RoundParticipantEntity)) {
            return false;
        }
        RoundParticipantEntity that = (RoundParticipantEntity) o;
        return Objects.equals(this.user.getUserId(), that.getUser().getUserId()) && Objects.equals(this.round.getRoundId(), that.getRound().getRoundId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(user.getUserId(), round.getRoundId());
    }

    public void updateStatus(StatusTag statusTag) {
        this.statusTag = statusTag;
    }

    public TaskEntity createTask(String detail, TaskType type) {
        TaskEntity task = TaskEntity.of(detail, type, this);
        tasks.add(task);
        return task;
    }

    public double calculateTaskProgress() {
        long totalTaskCount = tasks.size();
        long doneTaskCount = tasks.stream().filter(TaskEntity::isDone).count();
        double progress = (double) doneTaskCount / totalTaskCount;
        return Math.round(progress * 100.0) / 100.0;
    }

    public boolean isAttendedOrExpectedOrLate(){
        return (this.statusTag == StatusTag.ATTENDANCE) || (this.statusTag == StatusTag.LATE);
    }
}

