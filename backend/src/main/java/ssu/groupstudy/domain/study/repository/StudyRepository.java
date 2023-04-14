package ssu.groupstudy.domain.study.repository;

import org.springframework.data.repository.Repository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.user.domain.User;

import java.util.Optional;

public interface StudyRepository extends Repository<Study, Long> {
    void save(Study study);

}
