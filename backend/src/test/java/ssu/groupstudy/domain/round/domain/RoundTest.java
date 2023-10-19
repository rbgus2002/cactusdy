package ssu.groupstudy.domain.round.domain;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class RoundTest {
    @Nested
    class IsStudyTimeNull{
        private Round 약속시간_없는_회차 = new Round(Appointment.of(null, null));

        private Round 약속시간_있는_회차 = new Round(Appointment.of(null, LocalDateTime.now()));

        @Test
        @DisplayName("studyTime이 존재하지 않으면 true를 반환한다")
        void returnTrueIfStudyTimeIsNull(){
            // given
            // when
            boolean hasStudyTime = 약속시간_없는_회차.isStudyTimeNull();

            // then
            assertTrue(hasStudyTime);
        }

        @Test
        @DisplayName("studyTime이 존재하면 false를 반환한다")
        void returnFalseIfStudyTimeIsNotNull(){
            // given
            // when
            boolean hasStudyTime = 약속시간_있는_회차.isStudyTimeNull();

            // then
            assertFalse(hasStudyTime);
        }
    }
}