package ssu.groupstudy.domain.study.entity;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.common.entity.BaseWithSoftDeleteEntity;
import ssu.groupstudy.domain.common.enums.ColorCode;
import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.study.exception.CanNotLeaveStudyException;
import ssu.groupstudy.domain.study.exception.InviteAlreadyExistsException;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.exception.UserNotParticipatedException;

import javax.persistence.*;
import java.util.List;
import java.util.Optional;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "study")
public class StudyEntity extends BaseWithSoftDeleteEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long studyId;

    @Column(nullable = false, length = 14)
    private String studyName;

    @Column(length = 20)
    private String detail;

    @Column
    private String picture;

    @Column(nullable = false, unique = true, length = 6)
    private String inviteCode;

    @Embedded
    private Participants participants;

    private StudyEntity(String studyName, String detail, String color, UserEntity hostUser, String inviteCode) {
        this.studyName = studyName;
        this.detail = detail;
        this.participants = Participants.empty(new ParticipantEntity(hostUser, this), color);
        this.inviteCode = inviteCode;
    }

    private StudyEntity(String studyName, String detail) {
        this.studyName = studyName;
        this.detail = detail;
    }

    public static StudyEntity init(String studyName, String detail, String color, UserEntity hostUser, String inviteCode) {
        return new StudyEntity(studyName, detail, color, hostUser, inviteCode);
    }

    public static StudyEntity create(String studyName, String detail) {
        return new StudyEntity(studyName, detail);
    }

    public boolean isParticipated(UserEntity user) {
        return participants.existParticipant(new ParticipantEntity(user, this));
    }

    public void invite(UserEntity user) {
        if (isParticipated(user)) {
            throw new InviteAlreadyExistsException(ResultCode.DUPLICATE_INVITE_USER);
        }
        Optional<ParticipantEntity> hostParticipant = this.participants.getHostParticipant();
        String color = ColorCode.DEFAULT.getHex();
        if(hostParticipant.isPresent()){
            color = hostParticipant.get().getColor();
        }
        ParticipantEntity participant = ParticipantEntity.createWithColor(user, this, color);
        participants.addParticipant(participant);
    }

    public void leave(UserEntity user) {
        if (!isParticipated(user)) {
            throw new UserNotParticipatedException(ResultCode.USER_NOT_PARTICIPATED);
        }
        if (isHostUser(user) && participants.isGreaterThanOne()) {
            throw new CanNotLeaveStudyException(ResultCode.HOST_USER_CAN_NOT_LEAVE_STUDY);
        }
        participants.removeParticipant(new ParticipantEntity(user, this));
        if (participants.isNoOne()) {
            delete();
        }
    }

    public boolean isHostUser(UserEntity user) {
        return participants.isHostUser(user);
    }

    public List<ParticipantEntity> getParticipantList() {
        return this.participants.getParticipants();
    }

    public void updatePicture(String picture) {
        this.picture = picture;
    }

    public UserEntity getHostUser() {
        return this.participants.getHostUser();
    }

    public void edit(String studyName, String detail, UserEntity hostUser) {
        this.studyName = studyName;
        this.detail = detail;
        this.participants.changeHostUser(hostUser);
    }

    public void kickParticipant(UserEntity user) {
        if (!isParticipated(user)) {
            throw new UserNotParticipatedException(ResultCode.USER_NOT_PARTICIPATED);
        }
        participants.removeParticipant(new ParticipantEntity(user, this));
    }
}
