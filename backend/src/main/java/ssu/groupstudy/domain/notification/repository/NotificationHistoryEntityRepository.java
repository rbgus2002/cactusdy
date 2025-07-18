package ssu.groupstudy.domain.notification.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.notification.entity.NotificationHistoryEntity;

public interface NotificationHistoryEntityRepository extends JpaRepository<NotificationHistoryEntity, Long> {
}