package ssu.groupstudy.domain.round.domain;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.task.domain.Task;
import ssu.groupstudy.domain.task.domain.TaskType;
import ssu.groupstudy.domain.user.domain.User;

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
public class RoundParticipant {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_round_id")
    private Long id;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "userId", nullable = false)
    private User user;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "roundId", nullable = false)
    private Round round;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private StatusTag statusTag;

    @OneToMany(mappedBy = "roundParticipant", cascade = ALL, orphanRemoval = true)
    private final Set<Task> tasks = new HashSet<>();

    public RoundParticipant(User user, Round round) {
        this.user = user;
        this.round = round;
        this.statusTag = StatusTag.NONE;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof RoundParticipant)) {
            return false;
        }
        RoundParticipant that = (RoundParticipant) o;
        return Objects.equals(this.user.getUserId(), that.getUser().getUserId()) && Objects.equals(this.round.getRoundId(), that.getRound().getRoundId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(user.getUserId(), round.getRoundId());
    }

    public void updateStatus(StatusTag statusTag) {
        this.statusTag = statusTag;
    }

    public Task createTask(String detail, TaskType type) {
        Task task = Task.of(detail, type, this);
        tasks.add(task);
        return task;
    }

    public double calculateTaskProgress() {
        long totalTaskCount = tasks.size();
        long doneTaskCount = tasks.stream().filter(Task::isDone).count();
        double progress = (double) doneTaskCount / totalTaskCount;
        return Math.round(progress * 100.0) / 100.0;
    }
}

