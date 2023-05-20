package ssu.groupstudy.domain.study.repository;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import ssu.groupstudy.domain.study.domain.Participants;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.repository.UserRepository;

import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class ParticipantRepositoryTest {
    @Autowired
    ParticipantRepository participantRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StudyRepository studyRepository;

    private User getUser() {
        return SignUpRequest.builder()
                .name("최규현")
                .email("rbgus200@@naver.com")
                .nickName("규규")
                .phoneModel("")
                .picture("")
                .build().toEntity();
    }

    private Study getStudy(User hostUser) {
        return CreateStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .hostUserId(hostUser.getUserId())
                .detail("PS")
                .picture("")
                .build().toEntity(hostUser);
    }

//    @DisplayName("사용자별 스터디 정보 등록하기")
//    @Test
//    void 사용자별스터디정보등록() {
//        //given
//        final User hostUser = userRepository.save(getUser());
//        final User newUser = userRepository.save(SignUpRequest.builder()
//                .name("장재우")
//                .email("arkady@@naver.com")
//                .nickName("킹적화")
//                .build().toEntity());
//
//        final Study savedStudy = studyRepository.save(getStudy(hostUser));
//
//
//        //when
////        savedStudy.invite(newUser);
//        savedStudy.getParticipants().getParticipants().add(new Participant(newUser, saev))
//
//        //then
//        assertThat(savedStudy.getParticipants().getHostUser().getName()).isEqualTo("최규현");
//        assertThat(savedStudy.getParticipants().getParticipants().size()).isEqualTo(2);
//    }

    @DisplayName("사용자가 스터디에 속해있는 지 여부 검사")
    @Test
    void 사용자별스터디중복검사() {
        //given
        final User user = getUser();
        final User hostUser = userRepository.save(user);

        final Study study = getStudy(hostUser);
        final Study savedStudy = studyRepository.save(study);

        final Participant participant = Participant.builder()
                .study(savedStudy)
                .user(hostUser)
                .build();

        //when
        final Participant savedParticipant = participantRepository.save(participant);
        final Boolean existStudyPerUser = participantRepository.existsByUserAndStudy(user, study);

        //then
        assertThat(existStudyPerUser).isNotNull();
        assertThat(existStudyPerUser).isEqualTo(true);
    }
}