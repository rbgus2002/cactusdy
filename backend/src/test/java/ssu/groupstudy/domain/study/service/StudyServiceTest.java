package ssu.groupstudy.domain.study.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.response.StudySummaryResponse;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class StudyServiceTest extends ServiceTest {
    @InjectMocks
    private StudyService studyService;
    @Mock
    private UserRepository userRepository;
    @Mock
    private StudyRepository studyRepository;


    @Nested
    class 스터디생성{
        @Test
        @DisplayName("존재하지 않는 사용자가 스터디를 생성하면 예외를 던진다")
        void 실패_유저존재하지않음() {
            // given, when
            doReturn(Optional.empty()).when(userRepository).findByUserId(any(Long.class));

            // then
            assertThatThrownBy(() -> studyService.createStudy(알고리즘스터디CreateRequest))
                    .isInstanceOf(UserNotFoundException.class)
                    .hasMessage(ResultCode.USER_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("성공")
        void 성공() {
            // given
            doReturn(Optional.of(최규현)).when(userRepository).findByUserId(any(Long.class));
            doReturn(알고리즘스터디).when(studyRepository).save(any(Study.class));

            // when
            Long studyId = studyService.createStudy(알고리즘스터디CreateRequest);

            // then
            assertThat(studyId).isNotNull();
        }
    }

    @Nested
    class getStudySummaryResponse {
        @Test
        @DisplayName("존재하지 않는 스터디인 경우 예외를 던진다")
        void 실패_유저존재하지않음() {
            // given, when
            doReturn(Optional.empty()).when(studyRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> studyService.getStudySummary(-1L))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(ResultCode.STUDY_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("성공")
        void success(){
            // given
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findById(any(Long.class));

            // when
            StudySummaryResponse summaryResponse = studyService.getStudySummary(-1L);

            // then
            assertEquals("알고리즘", summaryResponse.getStudyName());
        }
    }
}