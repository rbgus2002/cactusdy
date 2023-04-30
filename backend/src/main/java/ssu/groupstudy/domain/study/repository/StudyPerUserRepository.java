package ssu.groupstudy.domain.study.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.Repository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.domain.StudyPerUser;
import ssu.groupstudy.domain.user.domain.User;

public interface StudyPerUserRepository extends JpaRepository<StudyPerUser, Long> {
    boolean existsByUserAndStudy(User user, Study study);
}
