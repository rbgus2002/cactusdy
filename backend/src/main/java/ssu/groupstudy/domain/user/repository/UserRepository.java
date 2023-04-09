package ssu.groupstudy.domain.user.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ssu.groupstudy.domain.user.domain.User;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
}
