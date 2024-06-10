package ssu.groupstudy.domain.task.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.task.entity.TaskEntity;

public interface TaskEntityRepository extends JpaRepository<TaskEntity, Long> {
}
