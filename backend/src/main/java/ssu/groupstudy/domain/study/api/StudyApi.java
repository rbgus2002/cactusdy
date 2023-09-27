package ssu.groupstudy.domain.study.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.study.dto.response.StudySummaryResponse;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.service.StudyService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/studies")
@RequiredArgsConstructor
@Tag(name = "Study", description = "스터디 API")
public class StudyApi {
    private final StudyService studyService;

    @Operation(summary = "새로운 스터디 생성")
    @PostMapping("")
    public ResponseDto register(@Valid @RequestBody CreateStudyRequest dto){
        Long studyId = studyService.createStudy(dto);
        return DataResponseDto.of("studyId", studyId);
    }

    @Operation(summary = "스터디 간단한 정보 가져오기")
    @GetMapping("")
    public ResponseDto getStudySummary(@RequestParam Long studyId){
        StudySummaryResponse studySummary = studyService.getStudySummary(studyId);
        return DataResponseDto.of("studySummary", studySummary);
    }
}