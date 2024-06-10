package ssu.groupstudy.domain.study.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.dto.DoneCount;
import ssu.groupstudy.domain.study.dto.response.ParticipantResponse;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantEntityRepository;
import ssu.groupstudy.domain.study.repository.StudyEntityRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;
import ssu.groupstudy.global.constant.ResultCode;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class ParticipantsServiceTest extends ServiceTest {
    @InjectMocks
    private ParticipantsService participantsService;
    @Mock
    private StudyEntityRepository studyEntityRepository;
    @Mock
    private UserEntityRepository userEntityRepository;
    @Mock
    private ParticipantEntityRepository participantEntityRepository;

    @Nested
    class GetParticipantsProfileImageList {
        @Test
        @DisplayName("존재하지 않는 스터디이면 예외를 던진다")
        void fail_studyNotFound() {
            // given
            doReturn(Optional.empty()).when(studyEntityRepository).findById(any(Long.class));

            // when, then
            assertThatThrownBy(() -> participantsService.getParticipantsProfileImageList(-1L))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(ResultCode.STUDY_NOT_FOUND.getMessage());
        }

//        @Test
//        @DisplayName("스터디에 소속된 사용자의 프로필 이미지를 모두 불러온다")
//        void success() {
//            // given
//            doReturn(Optional.of(알고리즘스터디)).when(studyEntityRepository).findByStudyId(any(Long.class));
//            알고리즘스터디.invite(장재우);
//
//            // when
//            List<ParticipantSummary> participantSummaryList = participantsService.getParticipantsProfileImageList(-1L);
//
//            // then
//            assertEquals(2, participantSummaryList.size());
//        }
    }

    @Nested
    class GetParticipant{
        @Test
        @DisplayName("스터디가 존재하지 않으면 예외를 던진다")
        void studyNotFound(){
            // given
            // when
            doReturn(Optional.empty()).when(studyEntityRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> participantsService.getParticipant(-1L, -1L))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(ResultCode.STUDY_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("사용자가 존재하지 않으면 예외를 던진다")
        void userNotFound(){
            // given
            // when
            doReturn(Optional.of(알고리즘스터디)).when(studyEntityRepository).findById(any(Long.class));
            doReturn(Optional.empty()).when(userEntityRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> participantsService.getParticipant(-1L, -1L))
                    .isInstanceOf(UserNotFoundException.class)
                    .hasMessage(ResultCode.USER_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("스터디에 초대되어 있는지 검사한다")
        void isParticipated(){
            // given
            doReturn(Optional.of(알고리즘스터디)).when(studyEntityRepository).findById(any(Long.class));
            doReturn(Optional.of(최규현)).when(userEntityRepository).findById(any(Long.class));
            doReturn(List.of()).when(participantEntityRepository).findParticipantInfoByUser(any(UserEntity.class));
            doReturn(new DoneCount(0L,0L,0L)).when(studyEntityRepository).calculateDoneCount(any(UserEntity.class), any(StudyEntity.class));

            // when
            ParticipantResponse response = participantsService.getParticipant(-1L, -1L);
            char isParticipated = response.getIsParticipated();

            // then
            softly.assertThat(isParticipated).isEqualTo('Y');
        }
    }
}