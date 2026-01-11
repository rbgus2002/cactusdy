package ssu.groupstudy.api.notification.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.Set;

@Getter
@AllArgsConstructor
@Builder
@ToString
public class NotificationReadReqVo {
    @NotNull
    private Boolean readAll;

    private Set<Long> notificationIds;
}
