package ssu.groupstudy.api.study.vo;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.param.DoneCount;
import ssu.groupstudy.domain.study.param.StatusTagInfo;
import ssu.groupstudy.domain.study.param.ParticipantInfo;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.util.List;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ParticipantResVo {
    private Long userId;
    private String nickname;
    private String profileImage;
    private String statusMessage;
    private List<ParticipantInfo> participantInfoList;
    private List<StatusTagInfo> statusTagInfoList;
    private int doneRate;
    private int unDoneRate;
    private char isParticipated;


    private ParticipantResVo(UserEntity user, List<ParticipantInfo> participantInfoList, List<StatusTagInfo> statusTagInfoList, DoneCount doneCount, char isParticipated) {
        this.userId = user.getUserId();
        this.nickname = user.getNickname();
        this.profileImage = user.getPicture();
        this.statusMessage = user.getStatusMessage();
        this.participantInfoList = participantInfoList;
        this.statusTagInfoList = statusTagInfoList;
        this.doneRate = doneCount.getDoneRate();
        this.unDoneRate = doneCount.getUndoneRate();
        this.isParticipated = isParticipated;
    }

    public static ParticipantResVo of(UserEntity user, List<ParticipantInfo> participantInfoList, List<StatusTagInfo> statusTagInfo, DoneCount doneCount, char isParticipated) {
        return new ParticipantResVo(user, participantInfoList, statusTagInfo, doneCount, isParticipated);
    }
}
