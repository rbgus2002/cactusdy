package ssu.groupstudy.domain.round.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.study.domain.Study;

import java.util.List;
import java.util.Optional;

public interface RoundRepository extends JpaRepository<Round, Long> {
    Round save(Round round);

    Optional<Round> findByRoundId(Long roundId);

    List<Round> findRoundsByStudy(Study study);
}
