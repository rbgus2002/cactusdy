package ssu.groupstudy.domain.notification.event.subscribe;

import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.List;

@Getter
@RequiredArgsConstructor
@Builder
public class StudyTopicSubscribeEvent {
    private final List<String> fcmTokens;
    private final long studyId;
}
