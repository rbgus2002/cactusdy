package ssu.groupstudy.domain.notice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.notice.domain.CheckNotice;

public interface CheckNoticeRepository extends JpaRepository<CheckNotice, Long>{
    CheckNotice save(CheckNotice checkNotice);
}
