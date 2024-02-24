package ssu.groupstudy.domain.round.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.CustomRepositoryTest;
import ssu.groupstudy.domain.round.domain.Appointment;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.repository.UserRepository;

import java.time.LocalDateTime;
import java.util.List;
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
        Study 스터디 = studyRepository.findById(1L).get();
        User 장재우 = userRepository.findById(2L).get();
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
        Optional<Round> 회차 = roundRepository.findById(1L);
        Optional<Round> 삭제된회차 = roundRepository.findById(2L);

        // then
        softly.assertThat(회차).isNotEmpty();
        softly.assertThat(삭제된회차).isEmpty();
    }

    @Nested
    class FindRoundsByStudyOrderByStudyTime{
        @Test
        @DisplayName("스터디의 회차 목록을 null 값 우선, studyTime을 역순으로 정렬해서 가져온다")
        void orderByStudyTimeDesc(){
            // given
            Study 스터디 = studyRepository.findById(1L).get();

            // when
            List<Round> rounds = roundRepository.findRoundsByStudyOrderByStudyTime(스터디);
            Round 회차1_studyTime_null = rounds.get(0);
            Appointment 회차2 = rounds.get(2).getAppointment();
            Appointment 회차3 = rounds.get(3).getAppointment();

            // then
            softly.assertThat(회차2.getStudyTime()).isAfter(회차3.getStudyTime());
        }

        @Test
        @DisplayName("studyTime이 null인 회차가 여러 개면 roundId 역순으로 정렬해서 가져온다")
        void orderByStudyTimeDescAndRoundIdDesc(){
            // given
            Study 스터디 = studyRepository.findById(1L).get();

            // when
            List<Round> rounds = roundRepository.findRoundsByStudyOrderByStudyTime(스터디);
            Round 회차1 = rounds.get(0);
            Round 회차2 = rounds.get(1);

            // then
            softly.assertThat(회차1.getRoundId()).isGreaterThan(회차2.getRoundId());
        }
    }

    @Test
    @DisplayName("스터디가 가지는 회차의 개수를 가져온다")
    void countRoundByStudy(){
        // given
        Study 스터디 = studyRepository.findById(2L).get();

        // when
        Long roundCount = roundRepository.countRoundsByStudy(스터디);

        // then
        softly.assertThat(roundCount).isEqualTo(1);
    }

    @Test
    @DisplayName("스터디가 보여줄 가장 최신의 회차를 하나 가져온다")
    void findLatestRound(){
        // given
        Study 스터디 = studyRepository.findById(1L).get();
        Round 회차 = roundRepository.findById(1L).get();
        Appointment appointment = Appointment.of(null, LocalDateTime.now().plusDays(1L));

        // when
        회차.updateAppointment(appointment);
        Round 최신_회차 = roundRepository.findLatestRound(스터디.getStudyId()).get();

        // then
        softly.assertThat(회차.getRoundId()).isEqualTo(최신_회차.getRoundId());
    }

    @Test
    @DisplayName("회차 약속시간이 더 이른 회차의 개수를 가져온다")
    void countByStudyTimeLessThanEqual(){
        // given
        Study 스터디 = studyRepository.findById(1L).get();

        // when
        Long count = roundRepository.countByStudyTimeLessThanEqual(스터디, LocalDateTime.now());

        // then
        softly.assertThat(count).isEqualTo(2);
    }

    @Test
    @DisplayName("회차 약속시간이 정해진 회차의 개수를 가져온다")
    void countByStudyTimeIsNotNull(){
        // given
        Study 스터디 = studyRepository.findById(1L).get();

        // when
        Long count = roundRepository.countByStudyTimeIsNotNull(스터디);

        // then
        softly.assertThat(count).isEqualTo(2);

    }

    @Test
    @DisplayName("현재 시각 기준으로 남은 회차들을 가져온다")
    void findFutureRounds(){
        // given
        Study 스터디 = studyRepository.findById(1L).get();

        // when
        List<Round> futureRounds = roundRepository.findFutureRounds(스터디, LocalDateTime.now());

        // then
        softly.assertThat(futureRounds.size()).isGreaterThanOrEqualTo(1);
    }
}