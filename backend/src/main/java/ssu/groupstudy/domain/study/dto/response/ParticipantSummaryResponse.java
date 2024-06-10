package ssu.groupstudy.domain.study.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ParticipantSummaryResponse {
    private Long userId;
    private String picture;
    private String nickname;

    private ParticipantSummaryResponse(ParticipantEntity participant) {
        UserEntity user = participant.getUser();
        this.userId = user.getUserId();
        this.picture = user.getPicture();
        this.nickname = user.getNickname();
    }

    public static ParticipantSummaryResponse from(ParticipantEntity participant){
        return new ParticipantSummaryResponse(participant);
    }
}
