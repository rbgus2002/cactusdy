package ssu.groupstudy.domain.round.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.user.domain.User;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "rel_user_round")
public class UserRound {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name="userId", nullable = false)
    private User creator;

    @ManyToOne
    @JoinColumn(name="roundId", nullable = false)
    private Round round;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private StatusTag statusTag;

    @Column(nullable = false)
    private char deleteYn;
}

