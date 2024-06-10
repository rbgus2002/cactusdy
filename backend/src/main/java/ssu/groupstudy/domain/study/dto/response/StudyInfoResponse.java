package ssu.groupstudy.domain.study.dto.response;

import lombok.Getter;
import ssu.groupstudy.domain.round.entity.Appointment;
import ssu.groupstudy.domain.round.entity.RoundEntity;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.domain.round.dto.response.ParticipantProfileResponse;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.common.enums.TaskType;
import ssu.groupstudy.domain.task.dto.response.TaskGroup;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Getter
public class StudyInfoResponse {
    private Long studyId;
    private Long hostUserId;
    private String studyName;
    private String detail;
    private String picture;
    private String inviteCode;
    private String color;

    private Long roundSeq;
    private Long roundId;
    private String studyPlace;
    private LocalDateTime studyTime;
    private List<ParticipantProfileResponse> profiles;
    private Long roundParticipantId;
    private List<TaskGroup> taskGroups;

    public StudyInfoResponse(ParticipantEntity participant, Long roundSeq, RoundEntity latestRound, RoundParticipantEntity roundParticipant) {
        StudyEntity study = participant.getStudy();
        this.studyId = study.getStudyId();
        this.hostUserId = study.getHostUser().getUserId();
        this.studyName = study.getStudyName();
        this.detail = study.getDetail();
        this.picture = study.getPicture();
        this.inviteCode = study.getInviteCode();
        this.color = participant.getColor();

        this.roundSeq = roundSeq;
        if(latestRound != null){
            this.roundId = latestRound.getRoundId();
            Appointment appointment = latestRound.getAppointment();
            this.studyPlace = appointment.getStudyPlace();
            this.studyTime = appointment.getStudyTime();
            this.profiles = latestRound.getRoundParticipantsOrderByInvite().stream()
                    .map(ParticipantProfileResponse::from)
                    .collect(Collectors.toList());
            if(roundParticipant != null){
                this.roundParticipantId = roundParticipant.getId();
                this.taskGroups = Stream.of(TaskType.values())
                        .map(taskType -> TaskGroup.of(taskType, roundParticipant))
                        .collect(Collectors.toList());
            }
        }
    }

    public static StudyInfoResponse of(ParticipantEntity participant, Long roundSeq, RoundEntity latestRound, RoundParticipantEntity roundParticipant){
        return new StudyInfoResponse(participant, roundSeq, latestRound, roundParticipant);
    }
}
