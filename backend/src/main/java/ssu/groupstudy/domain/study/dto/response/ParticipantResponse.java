package ssu.groupstudy.domain.study.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.dto.DoneCount;
import ssu.groupstudy.domain.study.dto.StatusTagInfo;
import ssu.groupstudy.domain.study.dto.ParticipantInfo;
import ssu.groupstudy.domain.user.domain.User;

import java.util.List;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ParticipantResponse {
    private Long userId;
    private String nickname;
    private String profileImage;
    private String statusMessage;
    private List<ParticipantInfo> participantInfoList;
    private List<StatusTagInfo> statusTagInfoList;
    private int doneRate;
    private int unDoneRate;


    private ParticipantResponse(User user, List<ParticipantInfo> participantInfoList, List<StatusTagInfo> statusTagInfoList, DoneCount doneCount) {
        this.userId = user.getUserId();
        this.nickname = user.getNickname();
        this.profileImage = user.getPicture();
        this.statusMessage = user.getStatusMessage();
        this.participantInfoList = participantInfoList;
        this.statusTagInfoList = statusTagInfoList;
        this.doneRate = doneCount.getDoneRate();
        this.unDoneRate = doneCount.getUndoneRate();
    }

    public static ParticipantResponse of(User user, List<ParticipantInfo> participantInfoList, List<StatusTagInfo> statusTagInfo, DoneCount doneCount) {
        return new ParticipantResponse(user, participantInfoList, statusTagInfo, doneCount);
    }
}
