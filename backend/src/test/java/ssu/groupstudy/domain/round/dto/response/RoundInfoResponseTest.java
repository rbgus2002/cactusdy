package ssu.groupstudy.domain.round.dto.response;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import ssu.groupstudy.domain.common.ServiceTest;

import static org.junit.jupiter.api.Assertions.assertFalse;

class RoundInfoResponseTest extends ServiceTest {
    @Test
    @DisplayName("회차 약속시간이 현재보다 늦으면 isPlanned는 true를 반환한다")
    void isStudyTimeAfterCurrent(){
        // given, when
        RoundDto.RoundInfoResponse roundInfo = RoundDto.createRoundInfo(회차1);

        // then
        assertFalse(roundInfo.getIsPlanned());
    }

    @Test
    @DisplayName("inner class test")
    void test(){
        // given
        RoundDto.RoundDetailResponse roundInfo = RoundDto.createRoundDetail(회차1);

        assertFalse(roundInfo.getIsPlanned());
    }
}