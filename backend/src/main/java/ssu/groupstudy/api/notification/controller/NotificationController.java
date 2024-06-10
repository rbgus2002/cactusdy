package ssu.groupstudy.api.notification.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.domain.notification.service.NotificationService;
import ssu.groupstudy.api.common.vo.ResVo;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
@Tag(name = "Notification", description = "알림 API")
public class NotificationController {
    private final NotificationService notificationService;

    @Operation(summary = "스터디 참여자 콕찌르기")
    @GetMapping
    public ResVo notifyParticipant(@AuthenticationPrincipal CustomUserDetails userDetails,
                                   @RequestParam Long targetUserId,
                                   @RequestParam Long studyId,
                                   @RequestParam int count) {
        notificationService.stabParticipant(userDetails.getUser(), targetUserId, studyId, count);
        return ResVo.success();
    }

    @Operation(summary = "스터디 참여자의 과제 콕찌르기", description = "스터디 참여자가 과제를 완료하지 않았을 때 콕찌르기를 한다")
    @GetMapping("/tasks")
    public ResVo notifyTask(@AuthenticationPrincipal CustomUserDetails userDetails,
                            @RequestParam Long targetUserId,
                            @RequestParam Long studyId,
                            @RequestParam Long roundId,
                            @RequestParam Long taskId,
                            @RequestParam int count) {
        notificationService.stabParticipantTask(userDetails.getUser(), targetUserId, studyId, roundId, taskId, count);
        return ResVo.success();
    }

    @Operation(summary = "사용자 기기 FCM 토큰 삭제", description = "사용자가 로그아웃할 때 기기의 FCM 토큰을 삭제한다")
    @DeleteMapping("/tokens")
    public ResVo deleteFcmToken(@AuthenticationPrincipal CustomUserDetails userDetails, @RequestParam String token) {
        notificationService.deleteFcmToken(userDetails.getUser(), token);
        return ResVo.success();
    }
}
