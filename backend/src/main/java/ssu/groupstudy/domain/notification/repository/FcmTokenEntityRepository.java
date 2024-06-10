package ssu.groupstudy.domain.notification.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.notification.entity.FcmTokenEntity;

public interface FcmTokenEntityRepository extends JpaRepository<FcmTokenEntity, Long> {
}
