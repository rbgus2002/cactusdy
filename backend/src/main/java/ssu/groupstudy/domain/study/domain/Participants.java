package ssu.groupstudy.domain.study.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import ssu.groupstudy.domain.user.domain.User;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Embeddable
@NoArgsConstructor
@Getter
public class Participants {
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "userId", nullable = false)
    private User hostUser;

    @OneToMany(mappedBy = "study", fetch = FetchType.LAZY, cascade = CascadeType.PERSIST)
    private Set<Participant> participants = new HashSet<>();

    public static Participants empty(Participant participant) {
        return new Participants(participant);
    }

    private Participants(Participant participant) {
        participants.add(participant);
        this.hostUser = participant.getUser();
    }

    public boolean existParticipant(Participant participant) {
        return participants.contains(participant);
    }

    public void addParticipant(Participant participant) {
        participants.add(participant);
    }
}
