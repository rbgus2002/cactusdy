package ssu.groupstudy.domain.notification.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.common.enums.NotificationDataType;
import ssu.groupstudy.domain.notification.entity.NotificationHistoryEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface NotificationHistoryEntityRepository extends JpaRepository<NotificationHistoryEntity, Long> {
    
    Page<NotificationHistoryEntity> findByUserOrderByCreateDateDesc(UserEntity user, Pageable pageable);

    Optional<NotificationHistoryEntity> findByIdAndUser(Long id, UserEntity user);

    List<NotificationHistoryEntity> findByIdInAndUser(Collection<Long> ids, UserEntity user);

    List<NotificationHistoryEntity> findByUserAndIsReadFalse(UserEntity user);

    List<NotificationHistoryEntity> findByUserAndNotificationDataType(UserEntity user, NotificationDataType notificationDataType);
}
