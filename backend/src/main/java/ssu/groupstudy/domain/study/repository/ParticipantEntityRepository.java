package ssu.groupstudy.domain.study.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.dto.ParticipantInfo;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.util.List;
import java.util.Optional;

public interface ParticipantEntityRepository extends JpaRepository<ParticipantEntity, Long> {
    @Query("SELECT p " +
            "FROM ParticipantEntity p " +
            "WHERE p.user = :user " +
            "AND p.study = :study " +
            "AND p.study.deleteYn = 'N' " +
            "AND p.user.deleteYn = 'N'")
    Optional<ParticipantEntity> findByUserAndStudy(UserEntity user, StudyEntity study);


    @Query("SELECT p " +
            "FROM ParticipantEntity p " +
            "WHERE p.user = :user " +
            "AND p.study.deleteYn = 'N' " +
            "ORDER BY p.createDate ASC")
    List<ParticipantEntity> findByUserOrderByCreateDate(UserEntity user);

    @Query("SELECT new ssu.groupstudy.domain.study.dto.ParticipantInfo(s.studyName, p.color, s.picture) " +
            "FROM ParticipantEntity p " +
            "JOIN StudyEntity s ON s.studyId = p.study.studyId " +
            "WHERE p.user = :user " +
            "AND s.deleteYn ='N' " +
            "ORDER BY p.createDate ASC")
    List<ParticipantInfo> findParticipantInfoByUser(UserEntity user);

    @Query("SELECT COUNT (p) " +
            "FROM ParticipantEntity p " +
            "WHERE p.user = :user " +
            "AND p.study.deleteYn = 'N' ")
    int countParticipationStudy(UserEntity user);
}
