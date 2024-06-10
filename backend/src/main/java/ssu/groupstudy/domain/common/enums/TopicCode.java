package ssu.groupstudy.domain.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum TopicCode {
    ALL_USERS("/topics/users", "[모든 사용자]"),
    NOTICE("/topics/notices%d", "[공지사항] id"),
    STUDY("/topics/studies%d", "[스터디] id"),
    ;

    private final String format;
    private final String description;

    public static String handleTopicString(TopicCode code, Long id){
        String topic = code.getFormat();
        if(code != TopicCode.ALL_USERS){
            return String.format(topic, id);
        }
        return topic;
    }
}
