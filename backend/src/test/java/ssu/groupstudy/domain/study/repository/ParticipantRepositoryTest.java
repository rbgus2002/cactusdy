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

    @DisplayName("사용자를 스터디에 초대한다.")
    @Test
    void 성공_스터디초대() {
        //given
        final User hostUser = userRepository.save(getUser());
        final Study savedStudy = studyRepository.save(getStudy(hostUser));

        final User newUser = userRepository.save(SignUpRequest.builder()
                .name("장재우")
                .email("arkady@@naver.com")
                .nickName("킹적화")
                .build().toEntity());

        //when
        savedStudy.invite(newUser);

        //then
        assertThat(savedStudy.getParticipants().getHostUser().getName()).isEqualTo("최규현");
        assertThat(savedStudy.getParticipants().getParticipants().size()).isEqualTo(2);
    }
}