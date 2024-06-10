package ssu.groupstudy.domain.rule.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ssu.groupstudy.domain.rule.entity.RuleEntity;

import java.util.List;
import java.util.Optional;

public interface RuleRepository extends JpaRepository<RuleEntity, Long> {
    @Query("SELECT r FROM RuleEntity r WHERE r.id = :ruleId AND r.deleteYn = 'N'")
    Optional<RuleEntity> findById(Long ruleId);

    @Query("SELECT r FROM RuleEntity r WHERE r.study.studyId = :studyId AND r.deleteYn = 'N' order by r.createDate")
    List<RuleEntity> findRulesByStudyIdOrderByCreateDate(Long studyId);
}
