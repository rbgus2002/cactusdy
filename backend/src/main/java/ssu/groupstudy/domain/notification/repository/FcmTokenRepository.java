package ssu.groupstudy.domain.notification.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.notification.domain.FcmToken;

public interface FcmTokenRepository extends JpaRepository<FcmToken, Long> {
}
