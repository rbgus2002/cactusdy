package ssu.groupstudy.domain.round.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.domain.common.enums.StatusTag;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ParticipantProfileResponse {
    private String picture;
    private StatusTag statusTag;

    private ParticipantProfileResponse(RoundParticipantEntity participant) {
        this.picture = participant.getUser().getPicture();
        this.statusTag = participant.getStatusTag();
    }

    public static ParticipantProfileResponse from(RoundParticipantEntity participant){
        return new ParticipantProfileResponse(participant);
    }
}
