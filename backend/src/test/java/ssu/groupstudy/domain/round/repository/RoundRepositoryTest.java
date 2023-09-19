package ssu.groupstudy.domain.round.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.RepositoryTest;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.domain.RoundParticipant;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

class RoundRepositoryTest extends RepositoryTest {
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private RoundRepository roundRepository;

    @Test
    @DisplayName("회차 생성 시에 회차 참여인원을 자동 생성한다.")
    void getUserRound() {
        // given
        userRepository.save(최규현);
        studyRepository.save(알고리즘스터디);

        // when
        roundRepository.save(회차1);

        // then
        assertAll(
                () -> assertThat(회차1.getRoundParticipants().size()).isEqualTo(1),
                () -> assertThat(회차1.getRoundParticipants()).contains(new RoundParticipant(최규현, 회차1))
        );
    }

    @Test
    @DisplayName("삭제되지 않은 회차를 조회한다.")
    void findByRoundIdAndDeleteYnIsN(){
        // given, when
        Optional<Round> 회차 = roundRepository.findByRoundIdAndDeleteYnIsN(1L);
        Optional<Round> 삭제된회차 = roundRepository.findByRoundIdAndDeleteYnIsN(2L);

        // then
        softly.assertThat(회차).isNotEmpty();
        softly.assertThat(삭제된회차).isEmpty();
    }
}