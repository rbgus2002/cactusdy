package ssu.groupstudy.domain.round.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.round.entity.RoundEntity;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.util.Optional;

public interface RoundParticipantEntityRepository extends JpaRepository<RoundParticipantEntity, Long> {
    Optional<RoundParticipantEntity> findByUserAndRound(UserEntity user, RoundEntity round);
}
