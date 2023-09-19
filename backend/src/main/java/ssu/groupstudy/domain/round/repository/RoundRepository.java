package ssu.groupstudy.domain.round.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.study.domain.Study;

import java.util.List;
import java.util.Optional;

public interface RoundRepository extends JpaRepository<Round, Long> {
    Round save(Round round);

    @Query("SELECT r FROM Round r WHERE r.roundId = :roundId AND r.deleteYn = 'N'")
    Optional<Round> findByRoundIdAndDeleteYnIsN(Long roundId);

    /**
     * 스터디의 회차 목록 가져오기
     * order by studyTime (null 값 우선)
     */
    @Query("SELECT r FROM Round r WHERE r.study = :study AND r.deleteYn = 'N' ORDER BY CASE WHEN r.appointment.studyTime IS NULL THEN 0 ELSE 1 END ASC, r.appointment.studyTime DESC")
    List<Round> findRoundsByStudyOrderByStudyTime(Study study);
}
