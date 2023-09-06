package ssu.groupstudy.domain.round.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.round.dto.request.AppointmentRequest;
import ssu.groupstudy.domain.round.dto.request.DetailRequest;
import ssu.groupstudy.domain.round.dto.response.RoundDto;
import ssu.groupstudy.domain.round.service.RoundService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/rounds")
@RequiredArgsConstructor
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

    @Operation(summary = "회차 상세보기", description = "회차의 세부 내용을 확인한다")
    @GetMapping("/details")
    public ResponseDto getDetail(@RequestParam Long roundId){
        RoundDto.RoundDetailResponse detail = roundService.getDetail(roundId);
        return DataResponseDto.of("detail", detail);
    }

    @Operation(summary = "회차 상세내용 수정", description = "회차 상세내용을 수정한다")
    @PatchMapping("/details")
    public ResponseDto updateDetail(@RequestParam Long roundId, @RequestBody DetailRequest dto){
        roundService.updateDetail(roundId, dto.getDetail());

        return ResponseDto.success();
    }

    // TODO : 회차 참여자들 정보는 스터디에 소속된 순으로 정렬하도록 변경 필요
    // TODO : 회차 정보는 약속 시간 순으로 정렬하도록 변경 필요
    @Operation(summary = "회차 목록 가져오기", description = "스터디에 속해있는 회차 정보를 가져온다")
    @GetMapping("/list")
    public ResponseDto getRoundInfoResponses(@RequestParam Long studyId){
        List<RoundDto.RoundInfoResponse> roundInfos = roundService.getRoundInfoResponses(studyId);

        return DataResponseDto.of("roundList", roundInfos);
    }

}
