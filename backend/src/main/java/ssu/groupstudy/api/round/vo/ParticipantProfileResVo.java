package ssu.groupstudy.api.round.vo;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.domain.common.enums.StatusTag;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ParticipantProfileResVo {
    private String picture;
    private StatusTag statusTag;

    private ParticipantProfileResVo(RoundParticipantEntity participant) {
        this.picture = participant.getUser().getPicture();
        this.statusTag = participant.getStatusTag();
    }

    public static ParticipantProfileResVo from(RoundParticipantEntity participant){
        return new ParticipantProfileResVo(participant);
    }
}
