package ssu.groupstudy.domain.study.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.dto.DoneCount;
import ssu.groupstudy.domain.study.dto.StatusTagInfo;
import ssu.groupstudy.domain.study.dto.StudyColorInfo;
import ssu.groupstudy.domain.user.domain.User;

import java.util.List;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ParticipantResponse {
    private Long userId;
    private String profileImage;
    private String statusMessage;
    private List<StudyColorInfo> studyColorInfoList;
    private List<StatusTagInfo> statusTagInfoList;
    private int doneRate;
    private int unDoneRate;


    private ParticipantResponse(User user, List<StudyColorInfo> studyColorInfoList, List<StatusTagInfo> statusTagInfoList, DoneCount doneCount) {
        this.userId = user.getUserId();
        this.profileImage = user.getPicture();
        this.statusMessage = user.getStatusMessage();
        this.studyColorInfoList = studyColorInfoList;
        this.statusTagInfoList = statusTagInfoList;
        this.doneRate = doneCount.getDoneRate();
        this.unDoneRate = doneCount.getUndoneRate();
    }

    public static ParticipantResponse of(User user, List<StudyColorInfo> studyColorInfoList, List<StatusTagInfo> statusTagInfo, DoneCount doneCount){
        return new ParticipantResponse(user, studyColorInfoList, statusTagInfo, doneCount);
    }
}
