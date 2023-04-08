package ssu.groupstudy.Entity;

import jakarta.persistence.*;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@NoArgsConstructor
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

    //TODO ENUM 처리
    private String statusTag;

}

