package ssu.groupstudy.domain.rule.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.CustomRepositoryTest;
import ssu.groupstudy.domain.rule.entity.RuleEntity;

import java.util.List;
import java.util.Optional;

@CustomRepositoryTest
class RuleEntityRepositoryTest {
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private RuleEntityRepository ruleEntityRepository;

    @Test
    @DisplayName("삭제되지 않은 규칙을 가져온다.")
    void findRuleById(){
        // given
        // when
        Optional<RuleEntity> 규칙 = ruleEntityRepository.findById(1L);
        Optional<RuleEntity> 삭제된_규칙 = ruleEntityRepository.findById(3L);

        // then
        softly.assertThat(규칙).isNotEmpty();
        softly.assertThat(삭제된_규칙).isEmpty();
    }

    @Test
    @DisplayName("특정 스터디에서 삭제되지 않은 규칙들을 모두 가져온다.")
    void findRulesByStudy(){
        // given
        // when
        List<RuleEntity> rules = ruleEntityRepository.findRulesByStudyIdOrderByCreateDate(1L);

        // then
        softly.assertThat(rules.size()).isGreaterThanOrEqualTo(2);
    }
}