package ssu.groupstudy.domain.rule.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.CustomRepositoryTest;
import ssu.groupstudy.domain.rule.domain.Rule;

import java.util.List;
import java.util.Optional;

@CustomRepositoryTest
class RuleRepositoryTest {
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private RuleRepository ruleRepository;

    @Test
    @DisplayName("삭제되지 않은 규칙을 가져온다.")
    void findRuleById(){
        // given
        // when
        Optional<Rule> 규칙 = ruleRepository.findById(1L);
        Optional<Rule> 삭제된_규칙 = ruleRepository.findById(3L);

        // then
        softly.assertThat(규칙).isNotEmpty();
        softly.assertThat(삭제된_규칙).isEmpty();
    }

    @Test
    @DisplayName("특정 스터디에서 삭제되지 않은 규칙들을 모두 가져온다.")
    void findRulesByStudy(){
        // given
        // when
        List<Rule> rules = ruleRepository.findRulesByStudyIdOrderByCreateDate(1L);

        // then
        softly.assertThat(rules.size()).isGreaterThanOrEqualTo(2);
    }
}