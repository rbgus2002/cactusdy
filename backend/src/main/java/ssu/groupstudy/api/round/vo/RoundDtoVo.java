package ssu.groupstudy.api.round.vo;

import lombok.Getter;
import ssu.groupstudy.domain.round.entity.RoundEntity;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Getter
public class RoundDtoVo { // [2024-06-10:최규현] TODO: 이름 변경

    @Getter
    public static class RoundDetailResVo {
        private Long roundId;
        private String studyPlace;
        private LocalDateTime studyTime;
        private Boolean isPlanned;
        private String detail;

        private RoundDetailResVo(RoundEntity round){
            this.roundId = round.getRoundId();
            this.studyPlace = round.getAppointment().getStudyPlace();
            this.studyTime = round.getAppointment().getStudyTime();
            this.isPlanned = isStudyTimeAfterCurrent(studyTime);
            this.detail = getDetailOrDefault(round);
        }
    }

    @Getter
    public static class RoundInfoResVo {
        private Long roundId;
        private String studyPlace;
        private LocalDateTime studyTime;
        private Boolean isPlanned;

        private List<RoundParticipantInfo> roundParticipantInfos;

        private RoundInfoResVo(RoundEntity round) {
            this.roundId = round.getRoundId();
            this.studyPlace = round.getAppointment().getStudyPlace();
            this.studyTime = round.getAppointment().getStudyTime();
            this.isPlanned = isStudyTimeAfterCurrent(studyTime);
            this.roundParticipantInfos = round.getRoundParticipantsOrderByInvite().stream()
                    .map(RoundParticipantInfo::from)
                    .collect(Collectors.toList());
        }
    }

    public static RoundDetailResVo createRoundDetail(RoundEntity round){
        return new RoundDetailResVo(round);
    }

    public static RoundInfoResVo createRoundInfo(RoundEntity round) {
        return new RoundInfoResVo(round);
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
