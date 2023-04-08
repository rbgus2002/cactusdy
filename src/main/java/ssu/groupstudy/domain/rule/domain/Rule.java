package ssu.groupstudy.domain.rule.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.global.domain.BaseEntity;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Rule extends BaseEntity {
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

