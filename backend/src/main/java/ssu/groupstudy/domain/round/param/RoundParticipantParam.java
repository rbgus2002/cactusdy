package ssu.groupstudy.domain.round.param;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import ssu.groupstudy.domain.common.enums.StatusTag;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class RoundParticipantParam {
    private Long roundParticipantId;
    private StatusTag statusTag;

    public static RoundParticipantParam from(RoundParticipantEntity roundParticipant){
        return new RoundParticipantParam(
                roundParticipant.getId(),
                roundParticipant.getStatusTag()
        );
    }
}
