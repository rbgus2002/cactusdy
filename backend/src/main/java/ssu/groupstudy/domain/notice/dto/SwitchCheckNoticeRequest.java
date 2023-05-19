package ssu.groupstudy.domain.notice.dto;

import lombok.*;

import javax.validation.constraints.NotNull;

@Getter
@AllArgsConstructor
@Builder
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class SwitchCheckNoticeRequest {
    @NotNull
    private Long noticeId;

    @NotNull
    private Long userId;
}
