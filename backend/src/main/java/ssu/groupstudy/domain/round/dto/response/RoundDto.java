package ssu.groupstudy.domain.round.dto.response;

import lombok.Getter;
import ssu.groupstudy.domain.round.entity.RoundEntity;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Getter
public class RoundDto {

    @Getter
    public static class RoundDetailResponse {
        private Long roundId;
        private String studyPlace;
        private LocalDateTime studyTime;
        private Boolean isPlanned;
        private String detail;

        private RoundDetailResponse(RoundEntity round){
            this.roundId = round.getRoundId();
            this.studyPlace = round.getAppointment().getStudyPlace();
            this.studyTime = round.getAppointment().getStudyTime();
            this.isPlanned = isStudyTimeAfterCurrent(studyTime);
            this.detail = getDetailOrDefault(round);
        }
    }

    @Getter
    public static class RoundInfoResponse {
        private Long roundId;
        private String studyPlace;
        private LocalDateTime studyTime;
        private Boolean isPlanned;

        private List<RoundParticipantInfo> roundParticipantInfos;

        private RoundInfoResponse(RoundEntity round) {
            this.roundId = round.getRoundId();
            this.studyPlace = round.getAppointment().getStudyPlace();
            this.studyTime = round.getAppointment().getStudyTime();
            this.isPlanned = isStudyTimeAfterCurrent(studyTime);
            this.roundParticipantInfos = round.getRoundParticipantsOrderByInvite().stream()
                    .map(RoundParticipantInfo::from)
                    .collect(Collectors.toList());
        }
    }

    public static RoundDetailResponse createRoundDetail(RoundEntity round){
        return new RoundDetailResponse(round);
    }

    public static RoundInfoResponse createRoundInfo(RoundEntity round) {
        return new RoundInfoResponse(round);
    }

    private static boolean isStudyTimeAfterCurrent(LocalDateTime studyTime){
        return (studyTime != null) && (studyTime.isAfter(LocalDateTime.now()));
    }

    private static String getDetailOrDefault(RoundEntity round) {
        String detail = round.getDetail();
        if(detail == null){
            return "";
        }
        return detail;
    }
}
