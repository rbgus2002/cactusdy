package ssu.groupstudy.domain.rule.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.rule.domain.Rule;
import ssu.groupstudy.domain.rule.dto.request.CreateRuleRequest;
import ssu.groupstudy.domain.rule.repository.RuleRepository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class RuleServiceTest extends ServiceTest {
    @InjectMocks
    private RuleService ruleService;

    @Mock
    private RuleRepository ruleRepository;

    @Mock
    private StudyRepository studyRepository;

    private Rule 규칙;

    @BeforeEach
    void init(){
        규칙 = new CreateRuleRequest(-1L, "detail").toEntity(알고리즘스터디);
        ReflectionTestUtils.setField(규칙, "ruleId", 5L);
    }

    @Nested
    class createRule{
        @Test
        @DisplayName("스터디가 존재하지 않으면 예외를 던진다")
        void fail_studyNotFound() {
            // given
            doReturn(Optional.empty()).when(studyRepository).findByStudyId(any(Long.class));

            // when, then
            assertThatThrownBy(() -> ruleService.createRule(new CreateRuleRequest(-1L, "detail")))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(ResultCode.STUDY_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("성공")
        void 성공() {
            // given
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findByStudyId(any(Long.class));
            doReturn(규칙).when(ruleRepository).save(any(Rule.class));

            // when
            Long ruleId = ruleService.createRule(new CreateRuleRequest(-1L, "detail"));

            // then
            assertThat(ruleId).isNotNull();
        }
    }

}