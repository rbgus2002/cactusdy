package ssu.groupstudy.domain.study.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.StatusTagInfo;
import ssu.groupstudy.domain.user.domain.User;

import java.util.List;
import java.util.Optional;

public interface StudyRepository extends JpaRepository<Study, Long> {
    @Query("SELECT s FROM Study s WHERE s.studyId = :studyId AND s.deleteYn = 'N'")
    Optional<Study> findById(Long studyId);

    @Query("SELECT new ssu.groupstudy.domain.study.dto.StatusTagInfo(rp.statusTag, COUNT(r.roundId)) FROM Study s " +
            "JOIN Round r ON s.studyId = r.study.studyId " +
            "JOIN RoundParticipant rp ON r.roundId = rp.round.roundId " +
            "WHERE s = :study " +
            "AND rp.user = :user " +
            "AND s.deleteYn = 'N' " +
            "AND r.deleteYn = 'N' " +
            "GROUP BY rp.statusTag")
    List<StatusTagInfo> calculateStatusTag(User user, Study study);
}
