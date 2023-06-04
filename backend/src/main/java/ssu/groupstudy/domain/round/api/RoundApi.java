package ssu.groupstudy.domain.round.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.dto.CreateRoundRequest;
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
    public ResponseDto createRound(@Valid @RequestBody CreateRoundRequest dto){
        Long roundId = roundService.createRound(dto);

        return DataResponseDto.of("roundId", roundId);
    }
}
