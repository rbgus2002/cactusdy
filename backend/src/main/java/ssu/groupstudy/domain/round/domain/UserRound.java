package ssu.groupstudy.domain.round.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.user.domain.User;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class UserRound {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userRoundId;

    @ManyToOne
    @JoinColumn(name="userId", nullable = false)
    private User creator;

    @ManyToOne
    @JoinColumn(name="roundId", nullable = false)
    private Round round;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatusTag statusTag;
}

