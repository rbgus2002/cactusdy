package ssu.groupstudy.domain.round.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import ssu.groupstudy.domain.round.service.RoundParticipantService;
import ssu.groupstudy.global.dto.ResponseDto;

@RestController
@RequestMapping("/api/rounds/participants")
@RequiredArgsConstructor
@Tag(name = "Round Participant", description = "회차 참여자 API")
public class RoundParticipantApi {
    private final RoundParticipantService roundParticipantService;

    @Operation(summary = "참여 상태 수정", description = "[NONE, ATTENDANCE, ATTENDANCE_EXPECTED, LATE, ABSENT] 중에 하나로 참여 상태를 변경한다")
    @PatchMapping("")
    public ResponseDto updateStatusTag(@RequestParam Long roundParticipantId, @RequestParam String statusTag){
        roundParticipantService.updateStatusTag(roundParticipantId, statusTag);

        return ResponseDto.success();
    }
}
