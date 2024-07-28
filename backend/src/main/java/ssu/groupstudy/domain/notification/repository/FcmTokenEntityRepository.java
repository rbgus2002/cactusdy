package ssu.groupstudy.domain.notification.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.notification.entity.FcmTokenEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.util.List;
import java.util.Optional;

public interface FcmTokenEntityRepository extends JpaRepository<FcmTokenEntity, Long> {
    Optional<FcmTokenEntity> findByTokenAndUser(String requestFcmToken, UserEntity user);

    List<FcmTokenEntity> findByUser(UserEntity user);
}
