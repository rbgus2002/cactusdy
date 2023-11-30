package ssu.groupstudy.domain.study.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantRepository;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.global.constant.ResultCode;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
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
}