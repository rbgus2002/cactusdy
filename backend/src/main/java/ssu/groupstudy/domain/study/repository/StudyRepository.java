package ssu.groupstudy.domain.study.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.study.domain.Study;

public interface StudyRepository extends JpaRepository<Study, Long> {
}
