package ssu.groupstudy.api.round.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.api.round.vo.AppointmentReqVo;
import ssu.groupstudy.api.round.vo.DetailReqVo;
import ssu.groupstudy.api.round.vo.RoundDtoVo;
import ssu.groupstudy.domain.round.service.RoundService;
import ssu.groupstudy.api.common.vo.DataResVo;
import ssu.groupstudy.api.common.vo.ResVo;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/rounds")
@RequiredArgsConstructor
@Tag(name = "RoundEntity", description = "회차 API")
public class RoundController {
    private final RoundService roundService;

    @Operation(summary = "회차 생성", description = "parameter에서 studyTime의 형식은 \"yyyy-MM-dd HH:mm\" 이다.")
    @PostMapping
    public ResVo createRound(@RequestParam Long studyId, @Valid @RequestBody AppointmentReqVo dto){
        Long roundId = roundService.createRound(studyId, dto);
        return DataResVo.of("roundId", roundId);
    }

    @Operation(summary = "회차 약속 수정", description = "시간 혹은 장소 약속을 수정한다. (시간 혹은 장소가 비어있으면 null로 업데이트)" +
            " // studyTime 형식은 \"yyyy-MM-dd HH:mm\" 이다.")
    @PatchMapping
    public ResVo updateAppointment(@RequestParam Long roundId, @Valid @RequestBody AppointmentReqVo dto){
        roundService.updateAppointment(roundId, dto);
        return ResVo.success();
    }

    @Operation(summary = "회차 상세보기", description = "회차의 세부 내용을 확인한다")
    @GetMapping("/details")
    public ResVo getDetail(@RequestParam Long roundId){
        RoundDtoVo.RoundDetailResVo detail = roundService.getDetail(roundId);
        return DataResVo.of("detail", detail);
    }

    @Operation(summary = "회차 상세내용 수정", description = "회차 상세내용을 수정한다")
    @PatchMapping("/details")
    public ResVo updateDetail(@RequestParam Long roundId, @RequestBody DetailReqVo dto){
        roundService.updateDetail(roundId, dto.getDetail());
        return ResVo.success();
    }

    @Operation(summary = "회차 목록 가져오기", description = "스터디에 속해있는 회차 정보를 가져온다")
    @GetMapping("/list")
    public ResVo getRoundInfoResponses(@RequestParam Long studyId){
        List<RoundDtoVo.RoundInfoResVo> roundInfos = roundService.getRoundInfoResponses(studyId);
        return DataResVo.of("roundList", roundInfos);
    }

    @Operation(summary = "회차 삭제하기", description = "방장만 회차를 삭제할 수 있다")
    @DeleteMapping
    public ResVo deleteRound(@RequestParam Long roundId, @AuthenticationPrincipal CustomUserDetails userDetails){
        roundService.deleteRound(roundId, userDetails.getUser());
        return ResVo.success();
    }
}
