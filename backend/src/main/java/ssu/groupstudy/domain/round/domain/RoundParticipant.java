package ssu.groupstudy.domain.round.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.notice.domain.CheckNotice;
import ssu.groupstudy.domain.task.domain.Task;
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
    @JoinColumn(name="userId", nullable = false)
    private User user;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name="roundId", nullable = false)
    private Round round;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private StatusTag statusTag;

    @OneToMany(mappedBy = "roundParticipant", cascade = ALL, orphanRemoval = true)
    private Set<Task> tasks = new HashSet<>();

    public RoundParticipant(User user, Round round){
        this.user = user;
        this.round = round;
        this.statusTag = StatusTag.NONE;
    }

    public void updateStatus(String statusTag){
        this.statusTag = StatusTag.valueOf(statusTag);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        RoundParticipant roundParticipant = (RoundParticipant) o;
        return Objects.equals(user, roundParticipant.user) && Objects.equals(round, roundParticipant.round);
    }

    @Override
    public int hashCode() {
        return Objects.hash(user, round);
    }
}

