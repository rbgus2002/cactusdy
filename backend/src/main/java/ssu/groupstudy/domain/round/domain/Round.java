package ssu.groupstudy.domain.round.domain;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.Where;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Participants;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.global.domain.BaseEntity;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

import static javax.persistence.CascadeType.PERSIST;
import static javax.persistence.FetchType.*;

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
    Set<RoundParticipant> roundParticipants = new HashSet<>();

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

    private void addParticipants(Participants participants){
        for(Participant participant : participants.getParticipants()){
            roundParticipants.add(new RoundParticipant(participant.getUser(), this));
        }
    }

    public void updateAppointment(Appointment appointment){
        this.appointment = appointment;
    }

    public void updateDetail(String detail){
        this.detail = detail;
    }
}