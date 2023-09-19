package ssu.groupstudy.domain.round.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.CustomRepositoryTest;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.repository.UserRepository;

import java.util.Optional;

@CustomRepositoryTest
class RoundRepositoryTest{
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private RoundRepository roundRepository;
    @Autowired
    private StudyRepository studyRepository;
    @Autowired
    private UserRepository userRepository;


    @Test
    @DisplayName("회차 생성 시에 회차 참여인원을 자동 생성한다.")
    // Study 생성자에서 방장을 Participants에 추가함 => 해당 코드에서는 participants.size에 포함 안됨
    void getUserRound() {
        // given
        Study 스터디 = studyRepository.findByStudyId(1L).get();
        User 장재우 = userRepository.findByUserId(2L).get();
        스터디.invite(장재우);

        // when
        Round 회차 = Round.builder()
                .study(스터디)
                .build();
        roundRepository.save(회차);

        // then
        softly.assertThat(회차.getRoundParticipants().size()).isEqualTo(1);
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