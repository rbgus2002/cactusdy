package ssu.groupstudy.domain.round.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.round.domain.Round;

public interface RoundRepository extends JpaRepository<Round, Long> {

}
