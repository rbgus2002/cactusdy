package ssu.groupstudy.domain.round.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.study.domain.Study;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface RoundRepository extends JpaRepository<Round, Long> {
    @Query("SELECT r FROM Round r WHERE r.roundId = :roundId AND r.deleteYn = 'N'")
    Optional<Round> findById(Long roundId);

    /**
     * 스터디의 회차 목록 가져오기
     * order by studyTime (null 값 우선)
     */
    @Query("SELECT r " +
            "FROM Round r " +
            "WHERE r.study = :study " +
            "AND r.deleteYn = 'N' " +
            "ORDER BY " +
            "CASE WHEN r.appointment.studyTime IS NULL THEN 0 ELSE 1 END ASC, " +
            "r.appointment.studyTime DESC, " +
            "r.roundId DESC")
    List<Round> findRoundsByStudyOrderByStudyTime(Study study);

    /**
     * 스터디가 보여줄 가장 최신의 회차를 하나 가져온다.
     * Priority
     * 1. 시간이 null이 아니면서 가장 가까운 시일 내의 미래의 회차
     * 2. 시간이 null인 회차 (과거에 생성한 회차 우선)
     * 3. 이미 시간이 지난 종료된 회차 (현재와 가장 가까운 회차 우선)
     */
    @Query(value =  "SELECT * " +
                    "FROM round " +
                    "WHERE 1=1 " +
                    "AND delete_yn = 'N' " +
                    "AND study_id = :studyId " +
                    "ORDER BY CASE " +
                            "WHEN study_time IS NOT NULL AND study_time > NOW() THEN 0 " +
                            "WHEN study_time IS NULL THEN 1 " +
                            "ELSE 2 " +
                            "END, " +
                        "CASE " +
                            "WHEN study_time IS NOT NULL AND study_time > NOW() THEN TIMESTAMPDIFF(DAY, NOW(), study_time) " +
                            "WHEN study_time IS NULL THEN TIMESTAMPDIFF(DAY, NOW(), create_date) " +
                            "ELSE TIMESTAMPDIFF(DAY, study_time, NOW()) " +
                            "END ASC " +
                    "LIMIT 1", nativeQuery = true)
    Optional<Round> findLatestRound(Long studyId);

    @Query("SELECT COUNT(r) FROM Round r WHERE r.study = :study AND r.deleteYn = 'N'")
    Long countRoundsByStudy(Study study);

    @Query("SELECT COUNT(r) FROM Round r WHERE r.study = :study AND r.deleteYn = 'N' AND r.appointment.studyTime <= :studyTime")
    Long countByStudyTimeLessThanEqual(Study study, LocalDateTime studyTime);

    @Query("SELECT COUNT(r) FROM Round r WHERE r.study = :study AND r.deleteYn = 'N' AND r.appointment.studyTime IS NOT NULL")
    Long countByStudyTimeIsNotNull(Study study);

    /**
     * 시각 기준으로 남은 회차들 가져오기
     * StudyTime이 null인 회차 + StudyTime이 현재 시각보다 큰 회차
     */
    @Query("SELECT r " +
            "FROM Round r " +
            "WHERE r.study = :study AND " +
            "r.deleteYn = 'N' AND " +
            "(r.appointment.studyTime IS NULL OR r.appointment.studyTime > :time)")
    List<Round> findFutureRounds(Study study, LocalDateTime time);
}
