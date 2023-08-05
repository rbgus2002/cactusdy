package ssu.groupstudy.domain.round.dto.response;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.domain.RoundParticipant;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class RoundInfoResponse {
    private Long roundId;
    private String studyPlace;
    private LocalDateTime studyTime;
    private Boolean isPlanned;

    private List<RoundParticipantInfo> roundParticipantInfos;

    private RoundInfoResponse(Round round) {
        this.roundId = round.getRoundId();
        this.studyPlace = round.getAppointment().getStudyPlace();
        this.studyTime = round.getAppointment().getStudyTime();
        this.isPlanned = isStudyTimeAfterCurrent(studyTime);
        this.roundParticipantInfos = createRoundParticipantInfos(round);
    }

    public static RoundInfoResponse from(Round round){
        return new RoundInfoResponse(round);
    }

    private boolean isStudyTimeAfterCurrent(LocalDateTime studyTime){
        return (studyTime != null) && (studyTime.isAfter(LocalDateTime.now()));
    }

    private List<RoundParticipantInfo> createRoundParticipantInfos(Round round) {
        return round.getRoundParticipants().stream()
                .map(RoundParticipantInfo::from)
                .collect(Collectors.toList());
    }
}
