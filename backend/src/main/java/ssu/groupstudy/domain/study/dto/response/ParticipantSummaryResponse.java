package ssu.groupstudy.domain.study.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.domain.Participant;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ParticipantSummaryResponse {
    private Long userId;
    private String picture;

    private ParticipantSummaryResponse(Participant participant) {
        this.userId = participant.getUser().getUserId();
        this.picture = participant.getUser().getPicture();
    }

    public static ParticipantSummaryResponse from(Participant participant){
        return new ParticipantSummaryResponse(participant);
    }
}
