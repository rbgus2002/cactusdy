package ssu.groupstudy.domain.round.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.round.domain.StatusTag;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ParticipantProfileResponse {
    private String picture;
    private StatusTag statusTag;

    private ParticipantProfileResponse(RoundParticipant participant) {
        this.picture = participant.getUser().getPicture();
        this.statusTag = participant.getStatusTag();
    }

    public static ParticipantProfileResponse from(RoundParticipant participant){
        return new ParticipantProfileResponse(participant);
    }
}
