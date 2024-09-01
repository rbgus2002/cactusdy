package ssu.groupstudy.domain.notification.event.push;

import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
@Builder
public class TaskDoneEvent {
    private final String nickname;
    private final String taskDetail;
    private final Long studyId;
    private final Long roundId;
}
