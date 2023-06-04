package ssu.groupstudy.domain.round.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.dto.CreateRoundRequest;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class RoundServiceTest extends ServiceTest {
    @InjectMocks
    private RoundService roundService;

    @Mock
    private RoundRepository roundRepository;

    @Mock
    private StudyRepository studyRepository;

    @Nested
    class createRound {
        @Test
        @DisplayName("스터디가 존재하지 않는 경우 예외를 던진다")
        void fail_studyNotFound() {
            // given
            doReturn(Optional.empty()).when(studyRepository).findByStudyId(any(Long.class));

            // when
            assertThatThrownBy(() -> roundService.createRound(라운드1CreateRoundRequest))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(ResultCode.STUDY_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("회차 생성 시에 스터디 장소와 약속 시간은 빈 값으로 둘수 있다") // api test에 있어야하는 것 아닌가?
        void success_emptyTimeAndPlace() {
            // given
            doReturn(라운드2_EmptyTimeAndPlace).when(roundRepository).save(any(Round.class));
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findByStudyId(any(Long.class));

            // when
            Long roundId = roundService.createRound(라운드2CreateRoundRequest_EmptyTimeAndPlace);

            // then
            assertThat(roundId).isNotNull();
        }

        @Test
        @DisplayName("성공")
        void success() {
            // given
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findByStudyId(any(Long.class));
            doReturn(라운드1).when(roundRepository).save(any(Round.class));

            // when
            Long roundId = roundService.createRound(라운드1CreateRoundRequest);

            // then
            assertThat(roundId).isNotNull();
        }
    }



}