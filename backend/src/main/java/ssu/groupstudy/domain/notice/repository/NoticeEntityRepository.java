package ssu.groupstudy.domain.notice.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;

import java.util.List;
import java.util.Optional;

public interface NoticeEntityRepository extends JpaRepository<NoticeEntity, Long> {
    @Query("SELECT n FROM NoticeEntity n WHERE n.noticeId = :noticeId AND n.deleteYn = 'N'")
    Optional<NoticeEntity> findById(Long noticeId);

    Page<NoticeEntity> findNoticesByStudyOrderByPinYnDescCreateDateDesc(StudyEntity study, Pageable pageable);

    List<NoticeEntity> findTop3ByStudyOrderByPinYnDescCreateDateDesc(StudyEntity study);

    @Query("SELECT n FROM NoticeEntity n WHERE n.study = :study AND n.deleteYn = 'N'")
    List<NoticeEntity> findNoticesByStudy(StudyEntity study);
}
