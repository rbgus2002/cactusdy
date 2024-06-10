package ssu.groupstudy.api.study.vo;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ParticipantSummaryResVo {
    private Long userId;
    private String picture;
    private String nickname;

    private ParticipantSummaryResVo(ParticipantEntity participant) {
        UserEntity user = participant.getUser();
        this.userId = user.getUserId();
        this.picture = user.getPicture();
        this.nickname = user.getNickname();
    }

    public static ParticipantSummaryResVo from(ParticipantEntity participant){
        return new ParticipantSummaryResVo(participant);
    }
}
