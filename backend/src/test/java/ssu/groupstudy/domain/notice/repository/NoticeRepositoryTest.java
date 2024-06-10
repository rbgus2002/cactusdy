package ssu.groupstudy.domain.notice.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import ssu.groupstudy.domain.common.CustomRepositoryTest;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.repository.UserRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;


@CustomRepositoryTest
class NoticeRepositoryTest{
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private StudyRepository studyRepository;
    @Autowired
    private NoticeRepository noticeRepository;

    @Nested
    class switchCheckNotice {
        @Test
        @DisplayName("공지사항 읽음 상태로 전환한다")
        void read() {
            // given
            UserEntity 최규현 = userRepository.findById(1L).get();
            Notice 공지사항 = noticeRepository.findById(1L).get();

            // when
            Character isChecked = 공지사항.switchCheckNotice(최규현);

            // then
            assertThat(isChecked).isEqualTo('Y');
        }

        @Test
        @DisplayName("공지사항을 안읽음 상태로 전환한다")
        void unread(){
            // given
            UserEntity 최규현 = userRepository.findById(1L).get();
            Notice 공지사항 = noticeRepository.findById(1L).get();

            // when
            공지사항.switchCheckNotice(최규현);
            Character isChecked = 공지사항.switchCheckNotice(최규현);

            // then
            assertThat(isChecked).isEqualTo('N');
        }
    }

    @Test
    @DisplayName("해당 스터디의 공지사항 리스트를 가져온다. 순서는 상단 고정 되어있는 공지사항을 우선으로 하고 작성 시각 기준 최신순으로 가져온다")
    void findNoticesByStudyOrderByPinYnDescCreateDateDesc() {
        // given
        Notice 공지사항1 = noticeRepository.findById(1L).get();
        Notice 공지사항2 = noticeRepository.findById(2L).get();
        Notice 공지사항3 = noticeRepository.findById(3L).get();
        Notice 공지사항4 = noticeRepository.findById(4L).get();
        공지사항3.switchPin(); // 공지사항3 상단 고정

        StudyEntity 알고리즘_스터디 = studyRepository.findById(1L).get();

        Pageable pageable = PageRequest.of(0, 10);

        // when
        Page<Notice> noticePage = noticeRepository.findNoticesByStudyOrderByPinYnDescCreateDateDesc(알고리즘_스터디, pageable);
        List<Notice> noticeList = noticePage.getContent();

        // then
        softly.assertThat(noticeList.size()).isEqualTo(4);
        softly.assertThat(noticeList.get(0).getPinYn()).isEqualTo('Y');
        softly.assertThat(noticeList.get(1).getCreateDate()).isAfter(noticeList.get(2).getCreateDate());
    }

    @Test
    @DisplayName("해당 스터디의 공지사항 리스트를 최대 3개 가져온다. 순서는 상단 고정 되어있는 공지사항을 우선으로 하고 작성 시각 기준 최신순으로 가져온다")
    void getNoticeListLimit3() {
        // given
        Notice 공지사항1 = noticeRepository.findById(1L).get();
        Notice 공지사항2 = noticeRepository.findById(2L).get();
        Notice 공지사항3 = noticeRepository.findById(3L).get();
        Notice 공지사항4 = noticeRepository.findById(4L).get();
        공지사항3.switchPin(); // 공지사항3 상단 고정

        StudyEntity 알고리즘_스터디 = studyRepository.findById(1L).get();

        // when
        List<Notice> noticeList = noticeRepository.findTop3ByStudyOrderByPinYnDescCreateDateDesc(알고리즘_스터디);

        // then
        softly.assertThat(noticeList.size()).isEqualTo(3);
        softly.assertThat(noticeList.get(0).getPinYn()).isEqualTo('Y');
    }

    @Nested
    class switchNoticePin{
        @Test
        @DisplayName("공지사항을 상단고정한다")
        void pin(){
            // given
            Notice 공지사항 = noticeRepository.findById(1L).get();

            // when
            char pinYn = 공지사항.switchPin();

            // then
            softly.assertThat(pinYn).isEqualTo('Y');
            softly.assertThat(공지사항.getPinYn()).isEqualTo('Y');
        }

        @Test
        @DisplayName("공지사항 상단고정을 해제한다")
        void unPin(){
            // given
            Notice 공지사항 = noticeRepository.findById(1L).get();

            // when
            공지사항.switchPin();
            char pinYn = 공지사항.switchPin();


            // then
            softly.assertThat(pinYn).isEqualTo('N');
            softly.assertThat(공지사항.getPinYn()).isEqualTo('N');
        }
    }

    @Nested
    class isRead{
        @Test
        @DisplayName("스터디원이 공지사항을 읽었으면 true를 반환한다")
        void read_true(){
            // given
            UserEntity 최규현 = userRepository.findById(1L).get();
            Notice 공지사항 = noticeRepository.findById(1L).get();
            공지사항.switchCheckNotice(최규현);

            // when
            boolean read = 공지사항.isRead(최규현);

            // then
            assertTrue(read);
        }
        
        @Test
        @DisplayName("스터디원이 공지사항을 읽지 않았으면 false를 반환한다")
        void read_false(){
            UserEntity 최규현 = userRepository.findById(1L).get();
            Notice 공지사항 = noticeRepository.findById(1L).get();
            공지사항.switchCheckNotice(최규현);
            공지사항.switchCheckNotice(최규현);

            // when
            boolean read = 공지사항.isRead(최규현);

            // then
            assertFalse(read);
        }
    }

    @Test
    @DisplayName("삭제된 공지사항을 읽는 경우 빈 값을 가져온다")
    void getNoticeDeleted(){
        // given
        Notice 공지사항 = noticeRepository.findById(1L).get();

        // when
        공지사항.deleteNotice();
        Optional<Notice> notice = noticeRepository.findById(공지사항.getNoticeId());

        // then
        softly.assertThat(notice).isEmpty();
    }

    @Test
    @DisplayName("스터디에 속한 공지사항을 모두 가져온다")
    void findNoticesByStudy(){
        // given
        StudyEntity 알고리즘_스터디 = studyRepository.findById(1L).get();

        // when
        List<Notice> notices = noticeRepository.findNoticesByStudy(알고리즘_스터디);

        // then
        softly.assertThat(notices.size()).isGreaterThan(1);
    }
}