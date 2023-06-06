package ssu.groupstudy.domain.round.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.dto.AppointmentRequest;
import ssu.groupstudy.domain.round.exception.RoundNotFoundException;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.global.ResultCode;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertAll;
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
    class CreateRound {
        @Test
        @DisplayName("스터디가 존재하지 않는 경우 예외를 던진다")
        void fail_studyNotFound() {
            // given
            doReturn(Optional.empty()).when(studyRepository).findByStudyId(any(Long.class));

            // when, then
            assertThatThrownBy(() -> roundService.createRound(-1L, 회차1AppointmentRequest))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(ResultCode.STUDY_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("회차 생성 시에 스터디 장소와 약속 시간은 빈 값으로 둘수 있다")
            // api test에 있어야하는 것 아닌가?
        void success_emptyTimeAndPlace() {
            // given
            doReturn(회차2_EmptyTimeAndPlace).when(roundRepository).save(any(Round.class));
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findByStudyId(any(Long.class));

            // when
            Long roundId = roundService.createRound(-1L, 회차2AppointmentRequest_EmptyTimeAndPlace);

            // then
            assertThat(roundId).isNotNull();
        }

        @Test
        @DisplayName("성공")
        void success() {
            // given
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findByStudyId(any(Long.class));
            doReturn(회차1).when(roundRepository).save(any(Round.class));

            // when
            Long roundId = roundService.createRound(-1L, 회차1AppointmentRequest);

            // then
            assertThat(roundId).isNotNull();
        }
    }

    @Nested
    class UpdateAppointment {
        @Test
        @DisplayName("존재하지 않는 회차의 경우 예외를 던진다")
        void fail_roundNotFound() {
            // given
            doReturn(Optional.empty()).when(roundRepository).findByRoundId(any(Long.class));

            // when, then
            assertThatThrownBy(() -> roundService.updateAppointment(-1L, 회차1AppointmentRequest))
                    .isInstanceOf(RoundNotFoundException.class)
                    .hasMessage(ResultCode.ROUND_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("회차의 장소 약속을 수정한다")
        void success_updatePlace() {
            // given
            doReturn(Optional.of(회차1)).when(roundRepository).findByRoundId(any(Long.class));

            // when
            roundService.updateAppointment(-1L, new AppointmentRequest(null, "장소변경"));

            // then
            assertThat(회차1.getAppointment().getStudyPlace()).isEqualTo("장소변경");
        }

        @Test
        @DisplayName("회차의 시간 약속을 수정한다")
        void success_updateTime() {
            // given
            doReturn(Optional.of(회차1)).when(roundRepository).findByRoundId(any(Long.class));

            // when
            roundService.updateAppointment(-1L, new AppointmentRequest(LocalDateTime.of(2024, 5, 17, 16, 0), null));

            // then
            assertThat(회차1.getAppointment().getStudyTime().getYear()).isEqualTo(2024);
        }

        @Test
        @DisplayName("회차의 장소, 시간 약속을 수정한다")
        void success_updatePlaceAndTime() {
            // given
            doReturn(Optional.of(회차1)).when(roundRepository).findByRoundId(any(Long.class));

            // when
            roundService.updateAppointment(-1L, new AppointmentRequest(LocalDateTime.of(2050, 5, 17, 16, 0), "숭실대"));

            // then
            assertAll(
                    () -> assertThat(회차1.getAppointment().getStudyPlace()).isEqualTo("숭실대"),
                    () -> assertThat(회차1.getAppointment().getStudyTime().getYear()).isEqualTo(2050)
            );
        }
    }
}