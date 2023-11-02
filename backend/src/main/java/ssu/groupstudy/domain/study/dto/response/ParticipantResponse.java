package ssu.groupstudy.domain.study.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.dto.DoneCount;
import ssu.groupstudy.domain.study.dto.StatusTagInfo;
import ssu.groupstudy.domain.user.domain.User;

import java.util.List;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ParticipantResponse {
    private Long userId;
    private String statusMessage;
    private List<String> studyNames;
    private List<StatusTagInfo> statusTagInfoList;
    private int doneRate;
    private int unDoneRate;


    private ParticipantResponse(User user, List<String> studyNames, List<StatusTagInfo> statusTagInfoList, DoneCount doneCount) {
        this.userId = user.getUserId();
        this.statusMessage = user.getStatusMessage();
        this.studyNames = studyNames;
        this.statusTagInfoList = statusTagInfoList;
        this.doneRate = doneCount.getDoneRate();
        this.unDoneRate = doneCount.getUndoneRate();
    }

    public static ParticipantResponse of(User user, List<String> studyNames, List<StatusTagInfo> statusTagInfo, DoneCount doneCount){
        return new ParticipantResponse(user, studyNames, statusTagInfo, doneCount);
    }
}
