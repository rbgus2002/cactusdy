package ssu.groupstudy.domain.rule.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ssu.groupstudy.domain.rule.domain.Rule;

import java.util.List;
import java.util.Optional;

public interface RuleRepository extends JpaRepository<Rule, Long> {
    @Query("SELECT r FROM Rule r WHERE r.id = :ruleId AND r.deleteYn = 'N'")
    Optional<Rule> findById(Long ruleId);

    @Query("SELECT r FROM Rule r WHERE r.study.studyId = :studyId AND r.deleteYn = 'N' order by r.createDate")
    List<Rule> findRulesByStudyIdOrderByCreateDate(Long studyId);
}
