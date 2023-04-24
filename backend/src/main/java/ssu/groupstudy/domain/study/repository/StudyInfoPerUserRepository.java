package ssu.groupstudy.domain.study.repository;

import org.springframework.data.repository.Repository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.domain.StudyInfoPerUser;
import ssu.groupstudy.domain.user.domain.User;

public interface StudyInfoPerUserRepository extends Repository<StudyInfoPerUser, Long> {
    StudyInfoPerUser save(StudyInfoPerUser studyInfoPerUser);
}
