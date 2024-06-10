package ssu.groupstudy.domain.round.entity;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.round.exception.UnauthorizedDeletionException;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.domain.BaseEntity;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import static javax.persistence.CascadeType.ALL;
import static javax.persistence.FetchType.LAZY;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Table(name = "round")
public class RoundEntity extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long roundId;

    @Column(length = 255)
    private String detail;

    @Embedded
    private Appointment appointment;

    @OneToMany(mappedBy = "round", cascade = ALL, orphanRemoval = true)
    private final List<RoundParticipantEntity> roundParticipants = new ArrayList<>();

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "studyId", nullable = false)
    private StudyEntity study;

    @Column(nullable = false)
    private char deleteYn;

    @Builder
    public RoundEntity(StudyEntity study, String studyPlace, LocalDateTime studyTime) {
        addParticipants(study.getParticipantList());
        this.study = study;
        this.appointment = Appointment.of(studyPlace, studyTime);
        this.deleteYn = 'N';
    }

    protected RoundEntity(Appointment appointment) {
        this.appointment = appointment;
    }

    private void addParticipants(List<ParticipantEntity> participants) {
        participants.stream()
                .map(participant -> new RoundParticipantEntity(participant.getUser(), this))
                .forEach(roundParticipants::add);
    }

    public void addParticipantWithoutDuplicates(RoundParticipantEntity participant) {
        if (roundParticipants.contains(participant)) {
            return;
        }
        roundParticipants.add(participant);
    }

    public void removeParticipant(RoundParticipantEntity participant){
        roundParticipants.remove(participant);
    }

    public void updateAppointment(Appointment appointment) {
        this.appointment = appointment;
    }

    public void updateDetail(String detail) {
        this.detail = detail;
    }

    public void deleteRound(UserEntity user) {
        validateDelete(user);
        this.deleteYn = 'Y';
    }

    private void validateDelete(UserEntity user) {
        if (!study.isHostUser(user)) {
            throw new UnauthorizedDeletionException(ResultCode.HOST_USER_ONLY_CAN_DELETE_ROUND);
        }
    }

    public Appointment getAppointment() {
        if (this.appointment == null) {
            return Appointment.empty();
        }
        return this.appointment;
    }

    public LocalDateTime getStudyTime() {
        return getAppointment().getStudyTime();
    }

    public boolean isStudyTimeNull() {
        return getAppointment().getStudyTime() == null;
    }

    public List<RoundParticipantEntity> getRoundParticipantsOrderByInvite() {
        return this.roundParticipants.stream()
                .filter(RoundParticipantEntity::isAttendedOrExpectedOrLate)
                .sorted(Comparator.comparing(RoundParticipantEntity::getId))
                .collect(Collectors.toList());
    }
}