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
import ssu.groupstudy.domain.study.dto.reuqest.InviteUserRequest;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.exception.InviteAlreadyExistsException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantRepository;
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
class StudyInviteServiceTest {
    @InjectMocks
    private StudyInviteService studyInviteService;

    @Mock
    private UserRepository userRepository;

    @Mock
    private StudyRepository studyRepository;

    @Mock
    private ParticipantRepository participantRepository;

    private InviteUserRequest getInviteUserRequest(){
        return InviteUserRequest.builder()
                .studyId(-1L)
                .userId(-1L)
                .build();
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

    private Participant getStudyPerUser(){
        return getInviteUserRequest().toEntity(getUser(), getStudy());
    }

    private Study getStudy() {
        return CreateStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .detail("알고문풀")
                .picture("")
                .hostUserId(0L)
                .build().toEntity(getUser());
    }

    @Nested
    class 스터디초대{
        @Test
        @DisplayName("존재하지 않는 사용자를 스터디에 초대하면 예외를 던진다")
        void 실패_사용자존재X(){
            // given
            doReturn(Optional.empty()).when(userRepository).findByUserId(any(Long.class));

            // when
            UserNotFoundException exception = assertThrows(UserNotFoundException.class, () -> studyInviteService.inviteUser(getInviteUserRequest()));

            // then
            assertThat(exception.getResultCode()).isEqualTo(ResultCode.USER_NOT_FOUND);
        }

        @Test
        @DisplayName("존재하지 않는 스터디에 사용자를 초대하면 예외를 던진다")
        void 실패_스터디존재X(){
            // given
            doReturn(Optional.of(getUser())).when(userRepository).findByUserId(any(Long.class));
            doReturn(Optional.empty()).when(studyRepository).findByStudyId(any(Long.class));

            // when
            StudyNotFoundException exception = assertThrows(StudyNotFoundException.class, () -> studyInviteService.inviteUser(getInviteUserRequest()));

            // then
            assertThat(exception.getResultCode()).isEqualTo(ResultCode.STUDY_NOT_FOUND);
        }

        // TODO : user, study는 id 값을 통해 equals() 비교를 하는데 repository에서 꺼내와야만 id 값이 있음.
        // TODO : entity 자체에 Builder 씌우긴 싫은데 어떡하면 좋을까 (씌우면 모든게 해결되긴 해.. ㅋㅋ)
//        @Test
//        @DisplayName("이미 해당 스터디에 존재하는 사용자를 다시 초대하면 예외를 던진다")
//        void 실패_이미사용자존재함(){
//            // given
//            doReturn(Optional.of(SignUpRequest.builder()
//                    .name("침착맨")
//                    .email("why@@naver.com")
//                    .nickName("king")
//                    .build().toEntity())).when(userRepository).findByUserId(any(Long.class));
//            doReturn(Optional.of(getStudy())).when(studyRepository).findByStudyId(any(Long.class));
//
//            // when
//            InviteAlreadyExistsException exception = assertThrows(InviteAlreadyExistsException.class, () -> studyInviteService.inviteUser(getInviteUserRequest()));
//
//            // then
//            assertThat(exception.getResultCode()).isEqualTo(ResultCode.DUPLICATE_INVITE_USER);
//        }
//
//        @Test
//        @DisplayName("성공")
//        void 성공(){
//            // given
//            doReturn(Optional.of(SignUpRequest.builder()
//                    .name("침착맨")
//                    .email("why@@naver.com")
//                    .nickName("king")
//                    .build().toEntity())).when(userRepository).findByUserId(any(Long.class));
//            doReturn(Optional.of(getStudy())).when(studyRepository).findByStudyId(any(Long.class));
//
//            // when
//            Long userId = studyInviteService.inviteUser(getInviteUserRequest());
//
//            // then
//            assertThat(userId).isNotNull();
//        }
    }

}