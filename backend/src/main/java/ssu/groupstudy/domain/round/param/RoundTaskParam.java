package ssu.groupstudy.domain.round.param;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.domain.task.param.TaskWithProgressParam;
import ssu.groupstudy.domain.user.param.UserParam;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class RoundTaskParam {
    private UserParam user;
    private RoundParticipantParam roundParticipant;
    private TaskWithProgressParam taskWithProgress;

    private RoundTaskParam(RoundParticipantEntity roundParticipant){
        this.user = UserParam.from(roundParticipant.getUser());
        this.roundParticipant = RoundParticipantParam.from(roundParticipant);
        this.taskWithProgress = TaskWithProgressParam.of(roundParticipant);
    }

    public static RoundTaskParam from(RoundParticipantEntity roundParticipant){
        return new RoundTaskParam(roundParticipant);
    }
}
