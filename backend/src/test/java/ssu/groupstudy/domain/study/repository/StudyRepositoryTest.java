package ssu.groupstudy.domain.study.repository;

import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.reuqest.RegisterStudyRequest;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.repository.UserRepository;

import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.*;

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class StudyRepositoryTest {
    @Autowired
    StudyRepository studyRepository;

    @Autowired
    private UserRepository userRepository;

    @DisplayName("스터디 등록")
    @Test
    void 스터디등록() {
        // given
        // TODO : user 직접 이렇게 하나하나 만들어줘야 하는가?
        final User user = SignUpRequest.builder()
                .name("최규현")
                .email("rbgus200@@naver.com")
                .nickName("규규")
                .phoneModel("")
                .picture("")
                .build().toEntity();
        final User hostUser = userRepository.save(user);
        final Study study = RegisterStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .hostUserId(hostUser.getUserId())
                .detail("PS")
                .picture("")
                .build().toEntity(hostUser, "", "");

        // when
        final Study savedStudy = studyRepository.save(study);

        // then
        assertThat(savedStudy.getStudyId()).isNotNull();
        assertThat(savedStudy.getStudyName()).isEqualTo("AlgorithmSSU");
        assertThat(savedStudy.getDetail()).isEqualTo("PS");
        assertThat(savedStudy.getHostUser()).isEqualTo(hostUser);
        assertThat(savedStudy.getInviteLink()).isEqualTo("");
        assertThat(savedStudy.getInviteQrCode()).isEqualTo("");
    }

    @DisplayName("studyId로 스터디 가져오기")
    @Test
    void 스터디가져오기() {
        //given
        final User user = SignUpRequest.builder()
                .name("최규현")
                .email("rbgus200@@naver.com")
                .nickName("규규")
                .phoneModel("")
                .picture("")
                .build().toEntity();
        final User hostUser = userRepository.save(user);
        final Study study = RegisterStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .hostUserId(hostUser.getUserId())
                .detail("PS")
                .picture("")
                .build().toEntity(hostUser, "", "");

        //when
        final Study saveStudy = studyRepository.save(study);
        final Optional<Study> studyGotten = studyRepository.findByStudyId(saveStudy.getStudyId());

        //then
        assertThat(studyGotten.get().getStudyId()).isNotNull();
        assertThat(studyGotten.get().getStudyName()).isEqualTo("AlgorithmSSU");
        assertThat(studyGotten.get().getDetail()).isEqualTo("PS");
    }
}