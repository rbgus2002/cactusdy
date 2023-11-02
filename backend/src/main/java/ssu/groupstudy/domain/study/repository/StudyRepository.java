package ssu.groupstudy.domain.study.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ssu.groupstudy.domain.study.domain.Study;

import java.util.Optional;

public interface StudyRepository extends JpaRepository<Study, Long> {
    @Query("SELECT s FROM Study s WHERE s.studyId = :studyId AND s.deleteYn = 'N'")
    Optional<Study> findById(Long studyId);
}
