package ssu.groupstudy.domain.study.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.domain.Participant;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ParticipantSummary{
    private Long userId;
    private String picture;

    private ParticipantSummary(Participant participant) {
        this.userId = participant.getUser().getUserId();
        this.picture = participant.getUser().getPicture();
    }

    public static ParticipantSummary from(Participant participant){
        return new ParticipantSummary(participant);
    }
}
