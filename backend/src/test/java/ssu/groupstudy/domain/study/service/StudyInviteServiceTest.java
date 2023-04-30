package ssu.groupstudy.domain.study.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.domain.StudyPerUser;
import ssu.groupstudy.domain.study.dto.reuqest.InviteUserRequest;
import ssu.groupstudy.domain.study.dto.reuqest.RegisterStudyRequest;
import ssu.groupstudy.domain.study.exception.InviteAlreadyExistsException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
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
class StudyInviteServiceTest {
    @InjectMocks
    private StudyInviteService studyInviteService;

    @Mock
    private UserRepository userRepository;

    @Mock
    private StudyRepository studyRepository;

    @Mock
    private StudyPerUserRepository studyPerUserRepository;

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

    private StudyPerUser getStudyPerUser(){
        return getInviteUserRequest().toEntity(getUser(), getStudy());
    }

    private Study getStudy() {
        return RegisterStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .detail("알고문풀")
                .picture("")
                .hostUserId(0L)
                .build().toEntity(getUser(), "", "");
    }

    @Test
    @DisplayName("스터디초대_실패_사용자존재X")
    void 스터디초대_실패_사용자존재X(){
        // given
        doReturn(Optional.empty()).when(userRepository).findByUserId(any(Long.class));

        // when
        UserNotFoundException exception = assertThrows(UserNotFoundException.class, () -> studyInviteService.inviteUserToStudy(getInviteUserRequest()));

        // then
        assertThat(exception.getResultCode()).isEqualTo(ResultCode.USER_NOT_FOUND);
    }

    @Test
    @DisplayName("스터디초대_실패_스터디존재X")
    void 스터디초대_실패_스터디존재X(){
        // given
        doReturn(Optional.of(getUser())).when(userRepository).findByUserId(any(Long.class));
        doReturn(Optional.empty()).when(studyRepository).findByStudyId(any(Long.class));

        // when
        StudyNotFoundException exception = assertThrows(StudyNotFoundException.class, () -> studyInviteService.inviteUserToStudy(getInviteUserRequest()));

        // then
        assertThat(exception.getResultCode()).isEqualTo(ResultCode.STUDY_NOT_FOUND);
    }

    // TODO : 모든 유효성검사 위 2개처럼 하나하나 검사해주어야 하는가? 하나의 service 내에 메소드에서 테스트 메소드는 몇 개를 만들어줘도 상관없는 것인가?
    @Test
    @DisplayName("스터디초대_실패_이미사용자존재함")
    void 스터디초대_실패_이미사용자존재함(){
        // given
        doReturn(Optional.of(getUser())).when(userRepository).findByUserId(any(Long.class));
        doReturn(Optional.of(getStudy())).when(studyRepository).findByStudyId(any(Long.class));
        doReturn(true).when(studyPerUserRepository).existsByUserAndStudy(any(User.class), any(Study.class));
        
        // when
        InviteAlreadyExistsException exception = assertThrows(InviteAlreadyExistsException.class, () -> studyInviteService.inviteUserToStudy(getInviteUserRequest()));
        
        // then
        assertThat(exception.getResultCode()).isEqualTo(ResultCode.DUPLICATE_INVITE_USER);
    }

    @Test
    @DisplayName("스터디초대_성공")
    void 스터디초대_성공(){
        // given
        doReturn(Optional.of(getUser())).when(userRepository).findByUserId(any(Long.class));
        doReturn(Optional.of(getStudy())).when(studyRepository).findByStudyId(any(Long.class));
        doReturn(false).when(studyPerUserRepository).existsByUserAndStudy(any(User.class), any(Study.class));
        doReturn(getStudyPerUser()).when(studyPerUserRepository).save(any(StudyPerUser.class));

        // when
        User invitedUser = studyInviteService.inviteUserToStudy(getInviteUserRequest());

        // then
        assertThat(invitedUser.getProfile().getName()).isEqualTo("최규현");
    }
}