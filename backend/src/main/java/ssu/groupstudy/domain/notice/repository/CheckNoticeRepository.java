package ssu.groupstudy.domain.notice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.notice.domain.CheckNotice;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.user.domain.User;

import java.util.Optional;

public interface CheckNoticeRepository extends JpaRepository<CheckNotice, Long>{
    CheckNotice save(CheckNotice checkNotice);

    Optional<CheckNotice> findByUserAndNotice(User user, Notice notice);
}
