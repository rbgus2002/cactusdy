package ssu.groupstudy.domain.user.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.Repository;
import ssu.groupstudy.domain.user.domain.User;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    boolean existsByProfileEmail(String email);

    User save(User user);

    Optional<User> findByUserId(Long userId);
}
