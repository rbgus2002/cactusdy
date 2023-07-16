package ssu.groupstudy.domain.study.domain;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Where;
import ssu.groupstudy.domain.study.exception.CanNotLeaveStudyException;
import ssu.groupstudy.domain.study.exception.InviteAlreadyExistsException;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.exception.UserNotParticipatedException;
import ssu.groupstudy.global.ResultCode;
import ssu.groupstudy.global.domain.BaseEntity;

import javax.persistence.*;

import static ssu.groupstudy.domain.study.domain.InviteCode.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
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
    private final InviteCode inviteCode = generate();

    @Embedded
    private Participants participants;

    @Column(nullable = false)
    private char deleteYn;

    @Builder
    public Study(String studyName, String detail, String picture, User hostUser) {
        this.studyName = studyName;
        this.detail = detail;
        this.picture = picture;
        this.participants = Participants.empty(new Participant(hostUser, this));
        this.deleteYn = 'N';
    }

    public boolean isParticipated(User user) {
        return participants.existParticipant(new Participant(user, this));
    }

    public void invite(User user) {
        if (isParticipated(user))
            throw new InviteAlreadyExistsException(ResultCode.DUPLICATE_INVITE_USER);

        participants.addParticipant(new Participant(user, this));
    }


    public void leave(User user) {
        if(!isParticipated(user)){
            throw new UserNotParticipatedException(ResultCode.USER_NOT_PARTICIPATED);
        }
        if(participants.getHostUser().equals(user)){
            throw new CanNotLeaveStudyException(ResultCode.HOST_USER_CAN_NOT_LEAVE_STUDY);
        }

        participants.removeParticipant(new Participant(user, this));
    }
}