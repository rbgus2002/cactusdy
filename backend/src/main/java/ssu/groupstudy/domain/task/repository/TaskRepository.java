package ssu.groupstudy.domain.task.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.task.domain.Task;

public interface TaskRepository extends JpaRepository<Task, Long> {
}
