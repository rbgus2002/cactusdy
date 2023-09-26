package ssu.groupstudy.domain.round.domain;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.round.exception.UnauthorizedDeletionException;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.ResultCode;
import ssu.groupstudy.global.domain.BaseEntity;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

import static javax.persistence.CascadeType.PERSIST;
import static javax.persistence.FetchType.LAZY;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
public class Round extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long roundId;

    @Column(length = 100)
    private String detail;

    @Embedded
    private Appointment appointment;

    @OneToMany(mappedBy = "round", cascade = PERSIST)
    private Set<RoundParticipant> roundParticipants = new HashSet<>();

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name="studyId", nullable = false)
    private Study study;

    @Column(nullable = false)
    private char deleteYn;

    @Builder
    public Round(Study study, String studyPlace, LocalDateTime studyTime){
        addParticipants(study.getParticipants());
        this.study = study;
        this.appointment = new Appointment(studyPlace, studyTime);
        this.deleteYn = 'N';
    }

    private void addParticipants(Set<Participant> participants){
        participants.stream()
                .map(participant -> new RoundParticipant(participant.getUser(), this))
                .forEach(roundParticipants::add);
    }

    public void updateAppointment(Appointment appointment){
        this.appointment = appointment;
    }

    public void updateDetail(String detail){
        this.detail = detail;
    }

    public void deleteRound(User user){
        validateDelete(user);
        this.deleteYn = 'Y';
    }

    private void validateDelete(User user) {
        if(!study.isHostUser(user)){
            throw new UnauthorizedDeletionException(ResultCode.HOST_USER_ONLY_CAN_DELETE_ROUND);
        }
    }
}