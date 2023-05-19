package ssu.groupstudy.domain.notice.repository;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import ssu.groupstudy.domain.notice.domain.CheckNotice;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.repository.UserRepository;

import java.util.Optional;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.not;
import static org.junit.jupiter.api.Assertions.*;

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class NoticeRepositoryTest {
    @Autowired
    private NoticeRepository noticeRepository;
    @Autowired
    private StudyRepository studyRepository;
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CheckNoticeRepository checkNoticeRepository;

    @DisplayName("cascade 옵션을 통한 영속성 전이 확인")
    @Test
    void oneToManyTest(){
        // given
        final User user1 = userRepository.save(SignUpRequest.builder()
                .name("최규현")
                .email("rbgus200@@naver.com")
                .nickName("규규")
                .build().toEntity());
        final User user2 = userRepository.save(SignUpRequest.builder()
                .name("장재우")
                .email("arkady@@naver.com")
                .nickName("최적화 머신")
                .build().toEntity());
        final Study study = studyRepository.save(CreateStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .hostUserId(user1.getUserId())
                .detail("PS")
                .build().toEntity(user1, "", ""));
        Notice notice = new Notice("공지", "내용", user1, study);

        Set<CheckNotice> set = notice.getCheckNotices();
        set.add(new CheckNotice(notice, user1));
        set.add(new CheckNotice(notice, user2));
        noticeRepository.save(notice);

        // when
        CheckNotice checkNotice = checkNoticeRepository.findByUserAndNotice(user1, notice).get();

        // then
        assertThat(checkNotice).isNotNull();
        assertThat(checkNotice.getUser()).isEqualTo(user1);
    }

    @DisplayName("고아 객체 삭제 테스트")
    @Test
    void orphanRemovalTest(){
        // given
        final User user1 = userRepository.save(SignUpRequest.builder()
                .name("최규현")
                .email("rbgus200@@naver.com")
                .nickName("규규")
                .build().toEntity());
        final User user2 = userRepository.save(SignUpRequest.builder()
                .name("장재우")
                .email("arkady@@naver.com")
                .nickName("최적화 머신")
                .build().toEntity());
        final Study study = studyRepository.save(CreateStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .hostUserId(user1.getUserId())
                .detail("PS")
                .build().toEntity(user1, "", ""));
        Notice notice = new Notice("공지", "내용", user1, study);

        Set<CheckNotice> set = notice.getCheckNotices();
        set.add(new CheckNotice(notice, user1));
        set.add(new CheckNotice(notice, user2));
        Notice savedNotice = noticeRepository.save(notice);

        // when
        savedNotice.getCheckNotices().remove(checkNoticeRepository.findByUserAndNotice(user1, notice).get());
        Optional<CheckNotice> checkNotice = checkNoticeRepository.findByUserAndNotice(user1, notice);

        // then
        assertThat(checkNotice).isEmpty();
    }
}