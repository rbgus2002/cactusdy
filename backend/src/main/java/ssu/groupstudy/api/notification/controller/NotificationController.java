package ssu.groupstudy.api.notification.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.api.common.vo.DataResVo;
import ssu.groupstudy.api.notification.vo.NotificationHistoryPageResVo;
import ssu.groupstudy.api.notification.vo.NotificationReadReqVo;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.domain.notification.service.FcmTokenService;
import ssu.groupstudy.domain.notification.service.NotificationHistoryService;
import ssu.groupstudy.domain.notification.service.NotificationParticipantService;
import ssu.groupstudy.api.common.vo.ResVo;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
@Tag(name = "Notification", description = "알림 API")
public class NotificationController {
    private final NotificationParticipantService notificationParticipantService;
    private final FcmTokenService fcmTokenService;
    private final NotificationHistoryService notificationHistoryService;

    @Operation(summary = "스터디 참여자 콕찌르기")
    @GetMapping
    public ResVo notifyParticipant(@AuthenticationPrincipal CustomUserDetails userDetails,
                                   @RequestParam Long targetUserId,
                                   @RequestParam Long studyId,
                                   @RequestParam int count) {
        notificationParticipantService.notifyParticipant(userDetails.getUser(), targetUserId, studyId, count);
        return ResVo.success();
    }

    @Operation(summary = "스터디 참여자의 과제 콕찌르기", description = "스터디 참여자가 과제를 완료하지 않았을 때 콕찌르기를 한다")
    @GetMapping("/tasks")
    public ResVo notifyParticipantTask(@AuthenticationPrincipal CustomUserDetails userDetails,
                                       @RequestParam Long targetUserId,
                                       @RequestParam Long studyId,
                                       @RequestParam Long roundId,
                                       @RequestParam Long taskId,
                                       @RequestParam int count) {
        notificationParticipantService.notifyParticipantTask(userDetails.getUser(), targetUserId, studyId, roundId, taskId, count);
        return ResVo.success();
    }

    @Operation(summary = "사용자 기기 FCM 토큰 삭제", description = "사용자가 로그아웃할 때 기기의 FCM 토큰을 삭제한다")
    @DeleteMapping("/tokens")
    public ResVo deleteFcmToken(@AuthenticationPrincipal CustomUserDetails userDetails, @RequestParam String token) {
        fcmTokenService.deleteFcmToken(userDetails.getUser(), token);
        return ResVo.success();
    }

    @Operation(summary = "알림 히스토리 조회", description = "사용자의 알림 히스토리를 최신순으로 조회한다")
    @GetMapping("/users/{userId}/notifications")
    public DataResVo<NotificationHistoryPageResVo> getNotificationHistory(@PathVariable Long userId,
                                                                          @RequestParam(defaultValue = "0") int page,
                                                                          @RequestParam(defaultValue = "20") int size) {
        NotificationHistoryPageResVo response = notificationHistoryService.getNotificationHistories(userId, PageRequest.of(page, size));
        return DataResVo.of("histories", response);
    }

    @Operation(summary = "알림 읽기 처리", description = "readAll=true면 전체 읽음, false면 notificationIds 기준으로 읽음 처리한다")
    @PatchMapping("/users/{userId}/notifications")
    public ResVo readNotifications(@PathVariable Long userId,
                                   @Valid @RequestBody NotificationReadReqVo request,
                                   @AuthenticationPrincipal CustomUserDetails userDetails) {
        notificationHistoryService.readNotifications(userId, request, userDetails.getUser());
        return ResVo.success();
    }
}
