package ssu.groupstudy.domain.study.entity;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import ssu.groupstudy.domain.study.exception.InvalidColorException;
import ssu.groupstudy.global.constant.ResultCode;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertEquals;

class ParticipantTest {
    @ParameterizedTest
    @DisplayName("16진수가 아닌 색상 정보를 입력하면 예외를 던진다")
    @ValueSource(strings = {"0xQ", "0x", "G", "1xA", "0x"})
    void invalidColorCode(String colorCode) {
        // given

        // when
        ParticipantEntity participant = new ParticipantEntity(null, null);

        // then
        assertThatThrownBy(() -> participant.setColor(colorCode))
                .isInstanceOf(InvalidColorException.class)
                .hasMessage(ResultCode.INVALID_COLOR.getMessage());
    }

    @ParameterizedTest
    @DisplayName("16진수 색상으로 변경한다.")
    @ValueSource(strings = {"0xAA", "0x123", "0xAF", "0x1"})
    void setColor(String colorCode) {
        // given
        ParticipantEntity participant = new ParticipantEntity(null, null);

        // when
        participant.setColor(colorCode);

        // then
        assertEquals(colorCode, participant.getColor());
    }
}