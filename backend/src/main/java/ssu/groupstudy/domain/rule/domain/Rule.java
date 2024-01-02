package ssu.groupstudy.domain.rule.domain;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.global.domain.BaseEntity;

import javax.persistence.*;

import static javax.persistence.FetchType.LAZY;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Table(name = "rule")
public class Rule extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "rule_id")
    private Long id;

    @Column(nullable = false, length = 50)
    private String detail;

    @Column(nullable = false)
    private char deleteYn;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name="studyId", nullable = false)
    private Study study;

    private Rule(String detail, Study study){
        this.detail = detail;
        this.study = study;
        this.deleteYn = 'N';
    }

    public static Rule create(String detail, Study study){
        return new Rule(detail, study);
    }

    public void delete() {
        this.deleteYn = 'Y';
    }

    public void updateDetail(String detail){
        this.detail = detail;
    }
}

