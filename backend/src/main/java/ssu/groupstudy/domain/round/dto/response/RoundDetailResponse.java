package ssu.groupstudy.domain.round.dto.response;

import lombok.Getter;
import ssu.groupstudy.domain.round.domain.Round;

import java.time.LocalDateTime;

@Getter
public class RoundDetailResponse {
    private Long roundId;
    private String studyPlace;
    private LocalDateTime studyTime;
    private Boolean isPlanned;
    private String detail;

    private RoundDetailResponse(Round round){
        this.roundId = round.getRoundId();
        this.studyPlace = round.getAppointment().getStudyPlace();
        this.studyTime = round.getAppointment().getStudyTime();
        this.isPlanned = isStudyTimeAfterCurrent(studyTime);
        this.detail = getDetail(round);
    }

    private String getDetail(Round round) {
        String detail = round.getDetail();
        if(detail == null){
            return "";
        }
        return detail;
    }

    public static RoundDetailResponse from(Round round){
        return new RoundDetailResponse(round);
    }

    private boolean isStudyTimeAfterCurrent(LocalDateTime studyTime){
        return (studyTime != null) && (studyTime.isAfter(LocalDateTime.now()));
    }
}
