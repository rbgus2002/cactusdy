package ssu.groupstudy.domain.notice.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.study.domain.Study;

import java.util.List;
import java.util.Optional;

public interface NoticeRepository extends JpaRepository<Notice, Long> {
    Optional<Notice> findByNoticeId(Long noticeId);

    Page<Notice> findNoticesByStudyOrderByPinYnDescCreateDateDesc(Study study, Pageable pageable);

    List<Notice> findTop3ByStudyOrderByPinYnDescCreateDateDesc(Study study);
}
