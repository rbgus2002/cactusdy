package ssu.groupstudy.domain.user.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.util.List;
import java.util.Optional;

public interface UserEntityRepository extends JpaRepository<UserEntity, Long> {
    @Query("SELECT u FROM UserEntity u WHERE u.userId = :userId AND u.deleteYn = false")
    Optional<UserEntity> findById(Long userId);

    @Query("SELECT u FROM UserEntity u WHERE u.userId IN :userIds AND u.deleteYn = false")
    List<UserEntity> findByIds(List<Long> userIds);

    boolean existsByPhoneNumber(String phoneNumber);

    @Query("SELECT u FROM UserEntity u WHERE u.phoneNumber = :phoneNumber AND u.deleteYn = false")
    Optional<UserEntity> findByPhoneNumber(String phoneNumber);
}
