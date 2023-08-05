package ssu.groupstudy.domain.round.repository;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import ssu.groupstudy.domain.common.RepositoryTest;
import ssu.groupstudy.domain.round.domain.RoundParticipant;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.*;

class RoundRepositoryTest extends RepositoryTest {
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
    @DisplayName("")
    void findBy(){
        // given
        
        // when
        
        // then
    }
}