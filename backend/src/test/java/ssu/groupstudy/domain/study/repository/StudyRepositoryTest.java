package ssu.groupstudy.domain.study.repository;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.repository.UserRepository;

import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.assertAll;

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class StudyRepositoryTest {
    @Autowired
    StudyRepository studyRepository;

    @Autowired
    private UserRepository userRepository;

    private User 최규현;
    private User 장재우;
    private User 홍예지;
    private Study 알고리즘스터디;

    private Study getStudy(User hostUser) {
        return CreateStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .hostUserId(hostUser.getUserId())
                .detail("PS")
                .picture("")
                .build().toEntity(hostUser);
    }

    private User getUser() {
        return SignUpRequest.builder()
                .name("최규현")
                .email("rbgus200@@naver.com")
                .nickName("규규")
                .phoneModel("")
                .picture("")
                .build().toEntity();
    }

    @BeforeEach
    void init() {
        최규현 = new SignUpRequest("최규현", "규규", "rbgus2002@naver.com").toEntity();
        장재우 = new SignUpRequest("장재우", "킹적화", "arkady@naver.com").toEntity();
        홍예지 = new SignUpRequest("홍예지", "찡찡이", "are_you_hungry@question.com").toEntity();
        알고리즘스터디 = new CreateStudyRequest("알고리즘스터디", "화이팅", "", -1L).toEntity(최규현);
    }

    /*
    FIXME : 쿼리 1번 날아가야할 거 2번씩 날아감.
     */
    @DisplayName("스터디 생성")
    @Test
    void 스터디생성() {
        // given
        최규현 = userRepository.save(최규현);

        // when
        final Study savedStudy = studyRepository.save(알고리즘스터디);

        // then
//        assertAll(
//                () -> assertThat(savedStudy.getStudyName()).isEqualTo("알고리즘스터디"),
//                () -> assertThat(savedStudy.getDetail()).isEqualTo("화이팅"),
//                () -> assertThat(savedStudy.getParticipants().getParticipants().size()).isEqualTo(1),
//                () -> assertThat(savedStudy.getParticipants().getHostUser()).isEqualTo(최규현)
//        );
    }

    @DisplayName("studyId로 스터디 가져오기")
    @Test
    void 스터디가져오기() {
        //given
        final User hostUser = userRepository.save(getUser());
        final Study study = getStudy(hostUser);

        //when
        final Study saveStudy = studyRepository.save(study);
        final Optional<Study> studyGotten = studyRepository.findByStudyId(saveStudy.getStudyId());

        //then
        assertThat(studyGotten.get().getStudyId()).isNotNull();
        assertThat(studyGotten.get().getStudyName()).isEqualTo("AlgorithmSSU");
        assertThat(studyGotten.get().getDetail()).isEqualTo("PS");
    }
}