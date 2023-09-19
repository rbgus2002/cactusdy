package ssu.groupstudy.domain.rule.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.rule.domain.Rule;

public interface RuleRepository extends JpaRepository<Rule, Long> {
}
