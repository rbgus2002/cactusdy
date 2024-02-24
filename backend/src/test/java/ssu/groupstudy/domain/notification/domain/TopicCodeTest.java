package ssu.groupstudy.domain.notification.domain;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import ssu.groupstudy.domain.notification.constants.TopicCode;

import static org.assertj.core.api.Assertions.assertThat;

class TopicCodeTest {
    @Test
    @DisplayName("토픽으로 사용할 문자열을 생성한다.")
    void handleTopicString(){
        // given
        TopicCode notice = TopicCode.NOTICE;

        // when
        String topicString = TopicCode.handleTopicString(notice, 1L);

        // then
        assertThat(topicString).isEqualTo("/topics/notices1");
    }
}