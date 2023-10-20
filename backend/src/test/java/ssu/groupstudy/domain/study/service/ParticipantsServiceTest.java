package ssu.groupstudy.domain.study.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.study.exception.ParticipantNotFoundException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantRepository;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.global.constant.ResultCode;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class ParticipantsServiceTest extends ServiceTest {
    @InjectMocks
    private ParticipantsService participantsService;
    @Mock
    private StudyRepository studyRepository;
    @Mock
    private ParticipantRepository participantRepository;

    @Nested
    class GetParticipantsProfileImageList {
        @Test
        @DisplayName("존재하지 않는 스터디이면 예외를 던진다")
        void fail_studyNotFound() {
            // given
            doReturn(Optional.empty()).when(studyRepository).findById(any(Long.class));

            // when, then
            assertThatThrownBy(() -> participantsService.getParticipantsProfileImageList(-1L))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(ResultCode.STUDY_NOT_FOUND.getMessage());
        }

//        @Test
//        @DisplayName("스터디에 소속된 사용자의 프로필 이미지를 모두 불러온다")
//        void success() {
//            // given
//            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findByStudyId(any(Long.class));
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
    class ModifyColor{
        @Test
        @DisplayName("존재하지 않는 Participant인 경우 예외를 던진다")
        void participantNotFound(){
            // given, when
            doReturn(Optional.empty()).when(participantRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> participantsService.modifyColor(-1L, "0x00"))
                    .isInstanceOf(ParticipantNotFoundException.class)
                    .hasMessage(ResultCode.PARTICIPANT_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("입력받은 색상으로 변경한다")
        void success(){
            // given
            final String colorCode = "0xFF";
            doReturn(Optional.of(스터디참여자_최규현)).when(participantRepository).findById(any(Long.class));

            // when
            participantsService.modifyColor(-1L, colorCode);

            // then
            assertEquals(colorCode, 스터디참여자_최규현.getColor());
        }
    }
}