package ssu.groupstudy.domain.rule.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.global.domain.BaseEntity;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
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

    @Builder
    Rule(String detail, Study study){
        this.detail = detail;
        this.study = study;
        this.deleteYn = 'N'; // TODO : 추후 자동으로 들어가게 변경
    }
}

