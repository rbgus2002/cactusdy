package ssu.groupstudy.domain.notice.repository;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import ssu.groupstudy.domain.common.RepositoryTest;
import ssu.groupstudy.domain.notice.domain.CheckNotice;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.user.exception.UserNotParticipatedException;
import ssu.groupstudy.global.ResultCode;

import java.util.List;

import static org.assertj.core.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.assertAll;

class NoticeRepositoryTest extends RepositoryTest {
    @Nested
    class switchCheckNotice {
        @Test
        @DisplayName("")
        void validateUserInStudy() {
            // given
            userRepository.save(최규현);
            userRepository.save(장재우);
            studyRepository.save(알고리즘스터디);
            noticeRepository.save(공지사항1);

            // when, then
            assertThatThrownBy(() -> 공지사항1.switchCheckNotice(장재우))
                    .isInstanceOf(UserNotParticipatedException.class)
                    .hasMessage(ResultCode.USER_NOT_PARTICIPATED.getMessage());
        }

        @Test
        @DisplayName("공지사항 읽음 상태를 반대의 상태로 바꾼다")
        void switchCheckNotice() {
            // given
            userRepository.save(최규현);
            studyRepository.save(알고리즘스터디);
            noticeRepository.save(공지사항1);

            // when
            String isChecked = 공지사항1.switchCheckNotice(최규현);
            CheckNotice checkNotice = checkNoticeRepository.findByUserAndNotice(최규현, 공지사항1).get();

            // then
            assertAll(
                    () -> assertThat(isChecked).isEqualTo("Checked"),
                    () -> assertThat(checkNotice.getNotice()).isEqualTo(공지사항1)
            );
        }
    }


    @Test
    @DisplayName("해당 스터디의 공지사항 리스트를 가져온다")
    void getNoticeList(){
        // given
        userRepository.save(최규현);
        studyRepository.save(알고리즘스터디);
        noticeRepository.save(공지사항1);
        noticeRepository.save(공지사항2);

        // when
        List<Notice> noticeList = noticeRepository.findNoticeByStudy(알고리즘스터디);

        // then
        assertThat(noticeList.size()).isEqualTo(2);
    }

}