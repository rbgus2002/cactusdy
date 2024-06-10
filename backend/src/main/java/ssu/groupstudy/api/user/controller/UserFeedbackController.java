package ssu.groupstudy.api.user.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.domain.common.enums.FeedbackType;
import ssu.groupstudy.api.user.vo.SendFeedbackReqVo;
import ssu.groupstudy.domain.feedback.service.UserFeedbackService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/feedbacks")
@RequiredArgsConstructor
@Tag(name = "FeedbackEntity", description = "사용자 피드백 API")
public class UserFeedbackController {
    private final UserFeedbackService userFeedbackService;

    @Operation(summary = "피드백 전송", description = "사용자 피드백을 전송한다")
    @PostMapping("/{feedbackType}")
    public ResponseDto sendFeedback(@PathVariable FeedbackType feedbackType, @Valid @RequestBody SendFeedbackReqVo request, @AuthenticationPrincipal CustomUserDetails userDetails) {
        Long feedbackId = userFeedbackService.sendFeedback(feedbackType, request, userDetails.getUser());
        return DataResponseDto.of("feedbackId", feedbackId);
    }
}
