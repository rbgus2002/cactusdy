package ssu.groupstudy.domain.notification.entity;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import ssu.groupstudy.domain.common.enums.TopicCode;

import static org.assertj.core.api.Assertions.assertThat;

class TopicCodeTest {
    @Test
    @DisplayName("토픽으로 사용할 문자열을 생성한다.")
    void handleTopicString(){
        // given
        TopicCode noticeTopicCode = TopicCode.NOTICE;

        // when
        String topicString = noticeTopicCode.handleTopicString(1L);

        // then
        assertThat(topicString).isEqualTo("/topics/notices1");
    }
}