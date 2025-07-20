package ssu.groupstudy.domain.notification.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.notification.entity.NotificationHistoryEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

public interface NotificationHistoryEntityRepository extends JpaRepository<NotificationHistoryEntity, Long> {
    
    Page<NotificationHistoryEntity> findByUserOrderByCreateDateDesc(UserEntity user, Pageable pageable);
}