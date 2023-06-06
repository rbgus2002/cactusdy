package ssu.groupstudy.domain.round.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.round.dto.AppointmentRequest;
import ssu.groupstudy.domain.round.service.RoundService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;

@RestController
@RequestMapping("/round")
@AllArgsConstructor
@Tag(name = "Round", description = "회차 API")
public class RoundApi {
    private final RoundService roundService;

    @Operation(summary = "회차 생성", description = "parameter에서 studyTime의 형식은 \"yyyy-MM-dd HH:mm\" 이다.")
    @PostMapping("")
    public ResponseDto createRound(@RequestParam Long studyId, @Valid @RequestBody AppointmentRequest dto){
        Long roundId = roundService.createRound(studyId, dto);

        return DataResponseDto.of("roundId", roundId);
    }

    @Operation(summary = "회차 약속 수정", description = "시간 혹은 장소 약속을 수정한다. (시간 혹은 장소가 비어있으면 null로 업데이트)" +
            " // studyTime 형식은 \"yyyy-MM-dd HH:mm\" 이다.")
    @PatchMapping("")
    public ResponseDto updateAppointment(@RequestParam Long roundId, @Valid @RequestBody AppointmentRequest dto){
        roundService.updateAppointment(roundId, dto);

        return ResponseDto.success();
    }
}
