package ssu.groupstudy.domain.round.dto.response;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import ssu.groupstudy.api.round.vo.RoundDtoVo;
import ssu.groupstudy.domain.common.ServiceTest;

import static org.junit.jupiter.api.Assertions.assertFalse;

class RoundInfoResVoTest extends ServiceTest {
    @Test
    @DisplayName("회차 약속시간이 현재보다 늦으면 isPlanned는 true를 반환한다")
    void isStudyTimeAfterCurrent(){
        // given, when
        RoundDtoVo.RoundInfoResVo roundInfo = RoundDtoVo.createRoundInfo(회차1);

        // then
        assertFalse(roundInfo.getIsPlanned());
    }

    @Test
    @DisplayName("inner class test")
    void test(){
        // given
        RoundDtoVo.RoundDetailResVo roundInfo = RoundDtoVo.createRoundDetail(회차1);

        assertFalse(roundInfo.getIsPlanned());
    }
}