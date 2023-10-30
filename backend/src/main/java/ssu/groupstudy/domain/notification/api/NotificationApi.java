package ssu.groupstudy.domain.notification.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.domain.notification.service.NotificationService;
import ssu.groupstudy.global.dto.ResponseDto;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
@Tag(name = "Notification", description = "알림 API")
public class NotificationApi {
    private final NotificationService notificationService;

    @Operation(summary = "스터디 참여자 콕찌르기")
    @GetMapping
    public ResponseDto notifyParticipant(@AuthenticationPrincipal CustomUserDetails userDetails, @RequestParam Long targetUserId, @RequestParam Long studyId) {
        notificationService.notifyParticipant(userDetails.getUser(), targetUserId, studyId);
        return ResponseDto.success();
    }}
