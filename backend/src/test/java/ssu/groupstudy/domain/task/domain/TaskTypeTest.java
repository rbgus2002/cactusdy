package ssu.groupstudy.domain.task.domain;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class TaskTypeTest {
    private final TaskType groupTask = TaskType.GROUP;
    private final TaskType personalTask = TaskType.PERSONAL;

    @Test
    @DisplayName("GROUP 이면 true를 반환한다")
    void isGroupTask(){
        // given
        // when
        boolean 그룹 = groupTask.isGroup();
        boolean 그룹_아님 = personalTask.isGroup();

        // then
        assertTrue(그룹);
        assertFalse(그룹_아님);
    }

    @Test
    @DisplayName("PERSONAL 이면 true를 반환한다")
    void isPersonalTask(){
        // given
        // when
        boolean 개인 = personalTask.isPersonal();
        boolean 개인_아님 = groupTask.isPersonal();

        // then
        assertTrue(개인);
        assertFalse(개인_아님);
    }
}