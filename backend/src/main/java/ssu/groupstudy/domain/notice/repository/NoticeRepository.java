package ssu.groupstudy.domain.notice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.notice.domain.Notice;

import java.util.Optional;

public interface NoticeRepository extends JpaRepository<Notice, Long> {
    Notice save(Notice notice);

    Optional<Notice> findByNoticeId(Long noticeId);
}
