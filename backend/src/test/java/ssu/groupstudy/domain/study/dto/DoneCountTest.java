package ssu.groupstudy.domain.study.dto;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class DoneCountTest {
    @Test
    @DisplayName("완료된 과제의 비율을 계산한다")
    void DoneCountTest(){
        // given
        DoneCount doneCount = new DoneCount(20L, 20L, 40L);

        // when
        int doneRate = doneCount.getDoneRate();

        // then
        assertThat(doneRate).isEqualTo(50);
    }

    @Test
    @DisplayName("완료되지 않은 과제의 비율을 계산한다")
    void getUndoneRate(){
        // given
        DoneCount doneCount = new DoneCount(30L, 70L, 100L);

        // when
        int doneRate = doneCount.getUndoneRate();

        // then
        assertThat(doneRate).isEqualTo(70);
    }
}