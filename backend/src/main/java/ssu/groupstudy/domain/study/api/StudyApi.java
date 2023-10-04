package ssu.groupstudy.domain.study.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.domain.study.dto.response.StudyInfoResponse;
import ssu.groupstudy.domain.study.dto.response.StudySummaryResponse;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.service.StudyService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/studies")
@RequiredArgsConstructor
@Tag(name = "Study", description = "스터디 API")
public class StudyApi {
    private final StudyService studyService;

    // TODO : 사용자 당 가질 수 있는 스터디 10개 제한 구현
    @Operation(summary = "새로운 스터디 생성")
    @PostMapping
    public ResponseDto register(@Valid @RequestBody CreateStudyRequest dto, @AuthenticationPrincipal CustomUserDetails userDetails){
        Long studyId = studyService.createStudy(dto, userDetails.getUser());
        return DataResponseDto.of("studyId", studyId);
    }

    @Operation(summary = "스터디 간단한 정보 가져오기")
    @GetMapping
    public ResponseDto getStudySummary(@RequestParam Long studyId){
        StudySummaryResponse studySummary = studyService.getStudySummary(studyId);
        return DataResponseDto.of("studySummary", studySummary);
    }

    @Operation(summary = "스터디 목록 가져오기", description = "사용자가 속한 스터디의 목록을 가져온다 (홈화면)")
    @GetMapping("/list")
    public ResponseDto getStudies(@AuthenticationPrincipal CustomUserDetails userDetails){
        List<StudyInfoResponse> studyInfos = studyService.getStudies(userDetails.getUser());
        return DataResponseDto.of("studyInfos",  studyInfos);
    }
}