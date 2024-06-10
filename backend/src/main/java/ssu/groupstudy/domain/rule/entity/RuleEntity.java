package ssu.groupstudy.domain.rule.entity;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.global.domain.BaseEntity;

import javax.persistence.*;

import static javax.persistence.FetchType.LAZY;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Table(name = "rule")
public class RuleEntity extends BaseEntity {
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
    private StudyEntity study;

    private RuleEntity(String detail, StudyEntity study){
        this.detail = detail;
        this.study = study;
        this.deleteYn = 'N';
    }

    public static RuleEntity create(String detail, StudyEntity study){
        return new RuleEntity(detail, study);
    }

    public void delete() {
        this.deleteYn = 'Y';
    }

    public void updateDetail(String detail){
        this.detail = detail;
    }
}

