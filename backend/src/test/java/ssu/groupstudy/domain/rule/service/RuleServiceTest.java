package ssu.groupstudy.domain.rule.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
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
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

@ExtendWith(MockitoExtension.class)
class RuleServiceTest {
    @InjectMocks
    private RuleService ruleService;

    @Mock
    private RuleRepository ruleRepository;

    @Mock
    private StudyRepository studyRepository;

    private CreateRuleRequest getCreateRuleRequest() {
        return CreateRuleRequest.builder()
                .studyId(-1L)
                .detail("숙제안해오면강퇴")
                .build();
    }

    private CreateStudyRequest getRegisterStudyRequest() {
        return CreateStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .detail("알고문풀")
                .picture("")
                .hostUserId(0L)
                .build();
    }

    private SignUpRequest getSignUpRequest() {
        return SignUpRequest.builder()
                .name("최규현")
                .email("rbgus200@@naver.com")
                .nickName("규규")
                .phoneModel("")
                .picture("")
                .build();
    }

    private Rule getRule(){
        return getCreateRuleRequest().toEntity(getStudy());
    }

    private User getUser() {
        return getSignUpRequest().toEntity();
    }

    private Study getStudy() {
        return getRegisterStudyRequest().toEntity(getUser(), "", "");
    }

    @Nested
    class 규칙생성{
        @Test
        @DisplayName("존재하지 않는 스터디에 규칙을 생성하면 예외를 던진다")
        void 실패_스터디존재X() {
            // given
            doReturn(Optional.empty()).when(studyRepository).findByStudyId(any(Long.class));

            // when
            StudyNotFoundException exception = assertThrows(StudyNotFoundException.class, () -> ruleService.createRule(getCreateRuleRequest()));

            // then
            assertThat(exception.getResultCode()).isEqualTo(ResultCode.STUDY_NOT_FOUND);
        }

        @Test
        @DisplayName("성공")
        void 성공() {
            // given
            doReturn(Optional.of(getStudy())).when(studyRepository).findByStudyId(any(Long.class));
            doReturn(getRule()).when(ruleRepository).save(any(Rule.class));

            // when
            Rule rule = ruleService.createRule(getCreateRuleRequest());

            // then
            assertThat(rule).isNotNull();
            assertThat(rule.getStudy().getStudyName()).isEqualTo("AlgorithmSSU");
        }
    }

}