package ssu.groupstudy.domain.study.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.entity.UserEntity;

import javax.persistence.Embeddable;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static javax.persistence.CascadeType.PERSIST;
import static javax.persistence.FetchType.LAZY;

@Embeddable
@NoArgsConstructor
@Getter
public class Participants {
    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "host_user_id", nullable = false)
    private UserEntity hostUser;

    @OneToMany(mappedBy = "study", cascade = PERSIST, orphanRemoval = true)
    private final List<ParticipantEntity> participants = new ArrayList<>();

    public static Participants empty(ParticipantEntity participant, String color) {
        participant.setColor(color);
        return new Participants(participant);
    }

    private Participants(ParticipantEntity participant) {
        participants.add(participant);
        this.hostUser = participant.getUser();
    }

    protected boolean existParticipant(ParticipantEntity participant) {
        return participants.contains(participant);
    }

    protected void addParticipant(ParticipantEntity participant) {
        participants.add(participant);
    }

    protected void removeParticipant(ParticipantEntity participant) {
        participants.remove(participant);
    }

    protected boolean isHostUser(UserEntity user) {
        return hostUser.equals(user);
    }

    protected boolean isGreaterThanOne() {
        return participants.size() > 1;
    }

    protected boolean isNoOne(){
        return participants.isEmpty();
    }

    protected void changeHostUser(UserEntity user) {
        this.hostUser = user;
    }

    public Optional<ParticipantEntity> getHostParticipant() {
        return participants.stream()
                .filter(participant -> participant.getUser().equals(hostUser))
                .findFirst();
    }
}
