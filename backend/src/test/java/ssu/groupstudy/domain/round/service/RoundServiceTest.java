package ssu.groupstudy.domain.round.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.round.entity.RoundEntity;
import ssu.groupstudy.api.round.vo.AppointmentReqVo;
import ssu.groupstudy.api.round.vo.RoundDtoVo;
import ssu.groupstudy.domain.round.exception.RoundNotFoundException;
import ssu.groupstudy.domain.round.exception.UnauthorizedDeletionException;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyEntityRepository;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;
import static ssu.groupstudy.domain.common.enums.ResultCode.*;

class RoundServiceTest extends ServiceTest {
    @InjectMocks
    private RoundService roundService;
    @Mock
    private RoundRepository roundRepository;
    @Mock
    private StudyEntityRepository studyEntityRepository;

    @Nested
    class CreateRound {
        @Test
        @DisplayName("스터디가 존재하지 않는 경우 예외를 던진다")
        void fail_studyNotFound() {
            // given
            doReturn(Optional.empty()).when(studyEntityRepository).findById(any(Long.class));

            // when, then
            assertThatThrownBy(() -> roundService.createRound(-1L, 회차1AppointmentReqVo))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(STUDY_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("회차 생성 시에 스터디 장소와 약속 시간은 빈 값으로 둘수 있다")
        void success_emptyTimeAndPlace() {
            // given
            doReturn(Optional.of(알고리즘스터디)).when(studyEntityRepository).findById(any(Long.class));
            doReturn(10L).when(roundRepository).countRoundsByStudy(any(StudyEntity.class));
            doReturn(회차2_EmptyTimeAndPlace).when(roundRepository).save(any(RoundEntity.class));

            // when
            Long roundId = roundService.createRound(-1L, 회차2AppointmentReqVo_EmptyTimeAndPlace);

            // then
            assertThat(roundId).isNotNull();
        }

        @Test
        @DisplayName("성공")
        void success() {
            // given
            doReturn(Optional.of(알고리즘스터디)).when(studyEntityRepository).findById(any(Long.class));
            doReturn(회차1).when(roundRepository).save(any(RoundEntity.class));

            // when
            Long roundId = roundService.createRound(-1L, 회차1AppointmentReqVo);

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
            doReturn(Optional.empty()).when(roundRepository).findById(any(Long.class));

            // when, then
            assertThatThrownBy(() -> roundService.updateAppointment(-1L, 회차1AppointmentReqVo))
                    .isInstanceOf(RoundNotFoundException.class)
                    .hasMessage(ROUND_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("회차의 장소 약속을 수정한다")
        void success_updatePlace() {
            // given
            doReturn(Optional.of(회차1)).when(roundRepository).findById(any(Long.class));

            // when
            roundService.updateAppointment(-1L, new AppointmentReqVo(null, "장소변경"));

            // then
            assertThat(회차1.getAppointment().getStudyPlace()).isEqualTo("장소변경");
        }

        @Test
        @DisplayName("회차의 시간 약속을 수정한다")
        void success_updateTime() {
            // given
            doReturn(Optional.of(회차1)).when(roundRepository).findById(any(Long.class));

            // when
            roundService.updateAppointment(-1L, new AppointmentReqVo(LocalDateTime.of(2024, 5, 17, 16, 0), null));

            // then
            assertThat(회차1.getAppointment().getStudyTime().getYear()).isEqualTo(2024);
        }

        @Test
        @DisplayName("회차의 장소, 시간 약속을 수정한다")
        void success_updatePlaceAndTime() {
            // given
            doReturn(Optional.of(회차1)).when(roundRepository).findById(any(Long.class));

            // when
            roundService.updateAppointment(-1L, new AppointmentReqVo(LocalDateTime.of(2050, 5, 17, 16, 0), "숭실대"));

            // then
            assertAll(
                    () -> assertThat(회차1.getAppointment().getStudyPlace()).isEqualTo("숭실대"),
                    () -> assertThat(회차1.getAppointment().getStudyTime().getYear()).isEqualTo(2050)
            );
        }
    }

    @Nested
    class GetDetail{
        @Test
        @DisplayName("회차가 존재하지 않으면 예외를 던진다")
        void roundNotFound(){
            // given, when
            doReturn(Optional.empty()).when(roundRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> roundService.getDetail(-1L))
                    .isInstanceOf(RoundNotFoundException.class)
                    .hasMessage(ROUND_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("회차의 상세설명이 null인 경우 빈 string을 반환한다")
        void GetDetail(){
            // given
            doReturn(Optional.of(회차1)).when(roundRepository).findById(any(Long.class));

            // when
            RoundDtoVo.RoundDetailResVo detail = roundService.getDetail(-1L);

            // then
            assertNotNull(detail.getDetail());
            assertEquals("", detail.getDetail());
        }

        @Test
        @DisplayName("회차의 상세설명을 가져온다")
        void success(){
            // given
            final String detailOf회차1 = "회차의 상세설명";
            회차1.updateDetail(detailOf회차1);
            doReturn(Optional.of(회차1)).when(roundRepository).findById(any(Long.class));

            // when
            RoundDtoVo.RoundDetailResVo detail = roundService.getDetail(-1L);

            // then
            assertEquals(detailOf회차1, detail.getDetail());
        }
    }

    @Nested
    class UpdateDetail{
        @Test
        @DisplayName("존재하지 않는 회차의 경우 예외를 던진다")
        void fail_roundNotFound() {
            // given
            doReturn(Optional.empty()).when(roundRepository).findById(any(Long.class));

            // when, then
            assertThatThrownBy(() -> roundService.updateDetail(-1L, ""))
                    .isInstanceOf(RoundNotFoundException.class)
                    .hasMessage(ROUND_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("회차 상세내용을 수정한다")
        void success(){
            // given
            doReturn(Optional.of(회차1)).when(roundRepository).findById(any(Long.class));

            // when
            roundService.updateDetail(-1L, "회차상세내용변경");

            // then
            assertThat(회차1.getDetail()).isEqualTo("회차상세내용변경");
        }
    }

    @Nested
    class DeleteRound{
        @Test
        @DisplayName("존재하지 않는 회차는 예외를 던진다")
        void roundNotFound(){
            // given, when
            doReturn(Optional.empty()).when(roundRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> roundService.deleteRound(-1L, 최규현))
                    .isInstanceOf(RoundNotFoundException.class)
                    .hasMessage(ROUND_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("방장이 아닌 사용자가 회차를 삭제하면 예외를 던진다")
        void userNotHost(){
            // given
            // when
            doReturn(Optional.of(회차1)).when(roundRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> roundService.deleteRound(-1L, 장재우))
                    .isInstanceOf(UnauthorizedDeletionException.class)
                    .hasMessage(HOST_USER_ONLY_CAN_DELETE_ROUND.getMessage());
        }

        @Test
        @DisplayName("회차를 삭제한다")
        void delete(){
            // given
            doReturn(Optional.of(회차1)).when(roundRepository).findById(any(Long.class));

            // when
            roundService.deleteRound(-1L, 최규현);

            // then
            softly.assertThat(회차1.isDeleteYn()).isEqualTo(true);
        }
    }
}