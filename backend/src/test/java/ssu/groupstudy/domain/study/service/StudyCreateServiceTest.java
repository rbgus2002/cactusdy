package ssu.groupstudy.domain.study.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.repository.StudyPerUserRepository;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

@ExtendWith(MockitoExtension.class)
class StudyCreateServiceTest {
    @InjectMocks
    private StudyCreateService studyCreateService;

    @Mock
    private UserRepository userRepository;

    @Mock
    private StudyRepository studyRepository;

    @Mock
    private StudyPerUserRepository studyPerUserRepository;

    private CreateStudyRequest getRegisterStudyRequest() {
        return CreateStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .detail("알고문풀")
                .picture("")
                .hostUserId(0L)
                .build();
    }

    private Study getStudy() {
        return getRegisterStudyRequest().toEntity(getUser());
    }


    private SignUpRequest getSignUpRequest() {
        return SignUpRequest.builder()
                .name("최규현")
                .email("rbgus200@@naver.com")
                .nickName("규규")
                .phoneModel("")
                .picture("")
                .build();
    }

    private User getUser() {
        return getSignUpRequest().toEntity();
    }

    @Nested
    class 스터디생성{
        @Test
        @DisplayName("존재하지 않는 사용자가 스터디를 생성하면 예외를 던진다")
        void 실패_유저존재하지않음() {
            // given
            CreateStudyRequest request = getRegisterStudyRequest();
            doReturn(Optional.empty()).when(userRepository).findByUserId(request.getHostUserId());

            // when
            UserNotFoundException exception = assertThrows(UserNotFoundException.class, () -> studyCreateService.createStudy(request));

            // then
            assertThat(exception.getResultCode()).isEqualTo(ResultCode.USER_NOT_FOUND);
        }

        // TODO : getUser, getStudy 메소드를 통해 가져오면 id 값이 존재하지 않는데 (실제 save 될 때 자동 생성되기 때문) 이는 제외하고 테스트해주면 되는가?
        @Test
        @DisplayName("성공")
        void 성공() {
            // given
            doReturn(Optional.of(getUser())).when(userRepository).findByUserId(any(Long.class));
            doReturn(getStudy()).when(studyRepository).save(any(Study.class));
            doReturn(new Participant(getUser(), getStudy())).when(studyPerUserRepository).save(any(Participant.class));

            // when
            Study newStudy = studyCreateService.createStudy(getRegisterStudyRequest());

            // then
            assertThat(newStudy.getStudyName()).isEqualTo("AlgorithmSSU");
            assertThat(newStudy.getParticipants().getHostUser().getName()).isEqualTo("최규현");
        }
    }
}