package ssu.groupstudy.Entity;

import jakarta.persistence.*;
import lombok.NoArgsConstructor;

@Entity
@NoArgsConstructor
public class Rule {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long ruleId;

    @Column(nullable = false, length = 50)
    private String detail;

    @Column(nullable = false)
    private char deleteYn;

    @ManyToOne
    @JoinColumn(name="studyId", nullable = false)
    private Study study;
}

