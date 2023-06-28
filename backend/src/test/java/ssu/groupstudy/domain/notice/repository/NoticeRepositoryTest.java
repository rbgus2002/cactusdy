package ssu.groupstudy.domain.notice.repository;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import ssu.groupstudy.domain.common.RepositoryTest;
import ssu.groupstudy.domain.notice.domain.CheckNotice;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.user.exception.UserNotParticipatedException;
import ssu.groupstudy.global.ResultCode;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import static org.assertj.core.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.assertAll;

class NoticeRepositoryTest extends RepositoryTest {
    @Nested
    class switchCheckNotice {
        @Test
        @DisplayName("스터디에 사용자가 소속되어있는지 검사한다")
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
        @DisplayName("공지사항 읽음 상태로 전환한다")
        void switchCheckNotice() {
            // given
            userRepository.save(최규현);
            studyRepository.save(알고리즘스터디);
            noticeRepository.save(공지사항1);

            // when
            Character isChecked = 공지사항1.switchCheckNotice(최규현);

            // then
            assertThat(isChecked).isEqualTo('Y');
        }
    }

    @Test
    @DisplayName("해당 스터디의 공지사항 리스트를 가져온다. 순서는 상단 고정 되어있는 공지사항을 우선으로 하고 작성 시각 기준 최신순으로 가져온다")
    void getNoticeList() {
        // given
        userRepository.save(최규현);
        studyRepository.save(알고리즘스터디);
        noticeRepository.save(공지사항1);
        noticeRepository.save(공지사항2);
        공지사항3.switchPin(); // 공지사항3 상단 고정
        noticeRepository.save(공지사항3);

        // when
        List<Notice> noticeList = noticeRepository.findNoticeByStudyOrderByPinYnDescCreateDateDesc(알고리즘스터디);

        // then
        assertAll(
                () -> assertThat(noticeList.size()).isEqualTo(3),
                () -> assertThat(noticeList.get(0)).isEqualTo(공지사항3),
                () -> assertThat(noticeList.get(1).getCreateDate()).isAfter(noticeList.get(2).getCreateDate())
        );
    }

    @Nested
    class switchNoticePin{
        @Test
        @DisplayName("공지사항을 상단고정한다")
        void pin(){
            // given
            userRepository.save(최규현);
            studyRepository.save(알고리즘스터디);
            noticeRepository.save(공지사항1);

            // when
            공지사항1.switchPin(); // 공지사항3 상단 고정

            // then
            assertThat(공지사항1.getPinYn()).isEqualTo('Y');
        }

        @Test
        @DisplayName("공지사항 상단고정을 해제한다")
        void unPin(){
            // given
            userRepository.save(최규현);
            studyRepository.save(알고리즘스터디);
            noticeRepository.save(공지사항1);

            // when
            공지사항1.switchPin(); // 공지사항3 상단 고정
            공지사항1.switchPin(); // 공지사항3 상단 고정 해제

            // then
            assertThat(공지사항1.getPinYn()).isEqualTo('N');
        }
    }

    @Test
    @DisplayName("공지사항에 체크 표시를 한 사용자 프로필 사진 리스트를 불러온다")
    void getCheckUserImageListByNoticeId(){
        // given
        userRepository.save(최규현);
        userRepository.save(장재우);
        studyRepository.save(알고리즘스터디);
        알고리즘스터디.invite(장재우);

        noticeRepository.save(공지사항1);

        공지사항1.switchCheckNotice(최규현);
        공지사항1.switchCheckNotice(장재우);

        // when
        Set<CheckNotice> checkNotices = 공지사항1.getCheckNotices();
        List<String> checkUserProfileList = new ArrayList<>();
        for(CheckNotice checkNotice : checkNotices)
            checkUserProfileList.add(checkNotice.getUser().getPicture());

        // then
        assertThat(checkUserProfileList.size()).isEqualTo(2);
    }
}