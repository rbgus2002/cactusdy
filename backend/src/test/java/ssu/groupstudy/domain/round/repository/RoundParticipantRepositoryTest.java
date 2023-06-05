package ssu.groupstudy.domain.round.repository;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import ssu.groupstudy.domain.common.RepositoryTest;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.global.ResultCode;


import static org.assertj.core.api.Assertions.assertThat;
import static ssu.groupstudy.domain.round.domain.StatusTag.*;

class RoundParticipantRepositoryTest extends RepositoryTest {

    @Nested
    class updateStatusTag {
        // TODO : 예외 처리 코드 추가
//        @Test
//        @DisplayName("잘못된 statusTag 이름으로 변경하면 예외를 던진다.")
//        void fail_invalidStatusTagName() {
//            // given
//            userRepository.save(최규현);
//            studyRepository.save(알고리즘스터디);
//            roundRepository.save(회차1);
//            RoundParticipant 회차_최규현 = roundParticipantRepository.findByUserAndRound(최규현, 회차1).orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));
//
//            // when, then
////            assertThatThrownBy(() -> 회차_최규현.updateStatus("INVALID_NAME"))
////                    .isInstanceOf()
////                    .hasMessage();
//            // when
//            회차_최규현.updateStatus("INVALID_NAME");
//
//            // then
//            assertThat(회차_최규현.getStatusTag()).isEqualTo(ATTENDANCE_EXPECTED);
//        }

        @Test
        @DisplayName("회차 참여자의 status tag를 변경한다")
        void updateStatusTag() {
            // given
            userRepository.save(최규현);
            studyRepository.save(알고리즘스터디);
            roundRepository.save(회차1);
            RoundParticipant 회차_최규현 = roundParticipantRepository.findByUserAndRound(최규현, 회차1).orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

            // when
            회차_최규현.updateStatus("ATTENDANCE_EXPECTED");

            // then
            assertThat(회차_최규현.getStatusTag()).isEqualTo(ATTENDANCE_EXPECTED);
        }
    }


}