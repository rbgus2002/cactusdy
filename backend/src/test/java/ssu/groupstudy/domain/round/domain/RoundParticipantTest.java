package ssu.groupstudy.domain.round.domain;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import ssu.groupstudy.domain.task.domain.Task;
import ssu.groupstudy.domain.task.domain.TaskType;

import static org.assertj.core.api.Assertions.assertThat;

class RoundParticipantTest {
    private RoundParticipant roundParticipant;

    @BeforeEach
    private void init(){
        roundParticipant = new RoundParticipant(null, null);

        Task task1 = roundParticipant.createTask("", TaskType.PERSONAL);
        Task task2 = roundParticipant.createTask("", TaskType.PERSONAL);
        Task task3 = roundParticipant.createTask("", TaskType.PERSONAL);

        task1.switchDoneYn();
        task2.switchDoneYn();
    }

    @Test
    @DisplayName("회차 참여자의 태스크 진행정도를 계산한다 (done / 전체)")
    void calculateTaskProgress(){
        // given
        // when
        double taskProgress = roundParticipant.calculateTaskProgress();

        // then
        assertThat(taskProgress).isEqualTo(0.67);
    }
}