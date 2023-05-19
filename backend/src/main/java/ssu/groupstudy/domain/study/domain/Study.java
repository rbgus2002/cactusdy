package ssu.groupstudy.domain.study.domain;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Where;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.domain.BaseEntity;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Where(clause = "delete_yn = 'N'")
public class Study extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long studyId;

    @Column(nullable = false, length = 30)
    private String studyName;

    @Column(length = 40)
    private String detail;

    private String picture;

    @Embedded
    private final Invite invite = Invite.generate();

    @Embedded
    private Participants participants;

    @Column(nullable = false)
    private char deleteYn;

    @Builder
    public Study(String studyName, String detail, String picture, User hostUser) {
        this.studyName = studyName;
        this.detail = detail;
        this.picture = picture;
        this.participants = Participants.empty(hostUser);
        this.deleteYn = 'N';
    }

    public boolean isParticipated(User user) {
        return participants.existParticipant(new Participant(user, this));
    }


}