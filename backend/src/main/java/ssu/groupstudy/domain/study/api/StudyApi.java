package ssu.groupstudy.domain.study.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.domain.study.dto.response.StudyCreateResponse;
import ssu.groupstudy.domain.study.dto.response.StudyInfoResponse;
import ssu.groupstudy.domain.study.dto.response.StudySummaryResponse;
import ssu.groupstudy.domain.study.dto.request.CreateStudyRequest;
import ssu.groupstudy.domain.study.dto.request.EditStudyRequest;
import ssu.groupstudy.domain.study.service.StudyService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;
import java.io.IOException;
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
    public ResponseDto register(@Valid @RequestPart("dto") CreateStudyRequest dto,
                                @RequestPart(value = "profileImage", required = false) MultipartFile profileImage,
                                @AuthenticationPrincipal CustomUserDetails userDetails) throws IOException {
        final StudyCreateResponse study = studyService.createStudy(dto, profileImage, userDetails.getUser());
        return DataResponseDto.of("study", study);
    }

    @Operation(summary = "스터디 간단한 정보 가져오기")
    @GetMapping
    public ResponseDto getStudySummary(@RequestParam Long studyId, @AuthenticationPrincipal CustomUserDetails userDetails) {
        final StudySummaryResponse studySummary = studyService.getStudySummary(studyId, userDetails.getUser());
        return DataResponseDto.of("studySummary", studySummary);
    }

    @Operation(summary = "스터디 목록 가져오기", description = "사용자가 속한 스터디의 목록을 가져온다 (홈화면)")
    @GetMapping("/list")
    public ResponseDto getStudies(@AuthenticationPrincipal CustomUserDetails userDetails) {
        final List<StudyInfoResponse> studyInfos = studyService.getStudies(userDetails.getUser());
        return DataResponseDto.of("studyInfos", studyInfos);
    }

    @Operation(summary = "스터디 편집하기", description = "스터디의 정보를 수정한다. 프로필 이미지가 변하지 않는 경우 null로 보내야 한다")
    @PatchMapping("/{studyId}")
    public ResponseDto editStudy(@PathVariable Long studyId,
                                 @Valid @RequestPart("dto") EditStudyRequest dto,
                                 @RequestPart(value = "profileImage", required = false) MultipartFile profileImage,
                                 @AuthenticationPrincipal CustomUserDetails userDetails) throws IOException {
        final Long editedStudyId = studyService.editStudy(studyId, dto, profileImage, userDetails.getUser());
        return DataResponseDto.of("studyId", editedStudyId);
    }
}