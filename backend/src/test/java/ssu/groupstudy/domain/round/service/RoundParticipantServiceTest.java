package ssu.groupstudy.domain.round.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.round.exception.RoundParticipantNotFoundException;
import ssu.groupstudy.domain.round.repository.RoundParticipantEntityRepository;
import ssu.groupstudy.domain.common.enums.ResultCode;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;
import static ssu.groupstudy.domain.common.enums.StatusTag.*;

class RoundParticipantServiceTest extends ServiceTest {
    @InjectMocks
    private RoundParticipantService roundParticipantService;

    @Mock
    private RoundParticipantEntityRepository roundParticipantEntityRepository;

    @Nested
    class updateStatusTag{
        @Test
        @DisplayName("회차 참여자를 찾을 수 없는 경우 예외를 던진다")
        void fail_roundParticipantNotFound(){
            // given
            doReturn(Optional.empty()).when(roundParticipantEntityRepository).findById(any(Long.class));

            // when, then
            assertThatThrownBy(() -> roundParticipantService.updateStatusTag(-1L, ATTENDANCE))
                    .isInstanceOf(RoundParticipantNotFoundException.class)
                    .hasMessage(ResultCode.ROUND_PARTICIPANT_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("회차 참여자의 statusTag를 변경한다.")
        void success(){
            // given
            doReturn(Optional.of(회차1_최규현)).when(roundParticipantEntityRepository).findById(any(Long.class));

            // when
            roundParticipantService.updateStatusTag(-1L, ATTENDANCE);

            // then
            assertThat(회차1_최규현.getStatusTag()).isEqualTo(ATTENDANCE);
        }
    }
}