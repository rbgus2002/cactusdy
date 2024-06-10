package ssu.groupstudy.domain.task.entity;

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
        boolean 그룹 = groupTask.isGroupType();
        boolean 그룹_아님 = personalTask.isGroupType();

        // then
        assertTrue(그룹);
        assertFalse(그룹_아님);
    }

    @Test
    @DisplayName("PERSONAL 이면 true를 반환한다")
    void isPersonalTask(){
        // given
        // when
        boolean 개인 = personalTask.isPersonalType();
        boolean 개인_아님 = groupTask.isPersonalType();

        // then
        assertTrue(개인);
        assertFalse(개인_아님);
    }

    @Test
    @DisplayName("인자로 받는 TaskType과 같은 타입이면 true를 반환한다")
    void isSameTypeOf(){
        // given
        // when
        boolean 그룹 = groupTask.isSameTypeOf(TaskType.GROUP);

        // then
        assertTrue(그룹);
    }
}