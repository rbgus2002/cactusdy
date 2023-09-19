package ssu.groupstudy.domain.round.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.CustomRepositoryTest;
import ssu.groupstudy.domain.round.domain.RoundParticipant;

import static ssu.groupstudy.domain.round.domain.StatusTag.ATTENDANCE_EXPECTED;

@CustomRepositoryTest
class RoundParticipantRepositoryTest {
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private RoundParticipantRepository roundParticipantRepository;

    @Nested
    class updateStatusTag {
        @Test
        @DisplayName("잘못된 statusTag 이름으로 변경하면 예외를 던진다.")
        void fail_invalidStatusTagName() {
            // given
            // when
            RoundParticipant 회차_최규현 = roundParticipantRepository.findById(1L).get();
            final String wrongTagName = "WRONG_TAG_NAME";

            // then
            softly.assertThatThrownBy(() -> 회차_최규현.updateStatus(wrongTagName))
                    .isInstanceOf(IllegalArgumentException.class);
        }

        @Test
        @DisplayName("회차 참여자의 status tag를 변경한다")
        void updateStatusTag() {
            // given
            RoundParticipant 회차_최규현 = roundParticipantRepository.findById(1L).get();

            // when
            회차_최규현.updateStatus("ATTENDANCE_EXPECTED");

            // then
            softly.assertThat(회차_최규현.getStatusTag()).isEqualTo(ATTENDANCE_EXPECTED);
        }
    }


}