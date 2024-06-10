package ssu.groupstudy.domain.notice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.notice.entity.CheckNoticeEntity;

public interface CheckNoticeRepository extends JpaRepository<CheckNoticeEntity, Long>{
    CheckNoticeEntity save(CheckNoticeEntity checkNotice);
}
