package ssu.groupstudy.domain.round.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.CustomRepositoryTest;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;

import static ssu.groupstudy.domain.common.enums.StatusTag.ATTENDANCE;

@CustomRepositoryTest
class RoundParticipantRepositoryTest {
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private RoundParticipantRepository roundParticipantRepository;

    @Nested
    class updateStatusTag {

        @Test
        @DisplayName("회차 참여자의 status tag를 변경한다")
        void updateStatusTag() {
            // given
            RoundParticipantEntity 회차_최규현 = roundParticipantRepository.findById(1L).get();

            // when
            회차_최규현.updateStatus(ATTENDANCE);

            // then
            softly.assertThat(회차_최규현.getStatusTag()).isEqualTo(ATTENDANCE);
        }
    }


}