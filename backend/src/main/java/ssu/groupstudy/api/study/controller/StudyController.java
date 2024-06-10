package ssu.groupstudy.api.study.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.api.study.vo.StudyCreateResVo;
import ssu.groupstudy.api.study.vo.StudyInfoResVo;
import ssu.groupstudy.api.study.vo.StudySummaryResVo;
import ssu.groupstudy.api.study.vo.CreateStudyReqVo;
import ssu.groupstudy.api.study.vo.EditStudyReqVo;
import ssu.groupstudy.domain.study.service.StudyService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;
import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/studies")
@RequiredArgsConstructor
@Tag(name = "StudyEntity", description = "스터디 API")
public class StudyController {
    private final StudyService studyService;

    @Operation(summary = "새로운 스터디 생성")
    @PostMapping
    public ResponseDto register(@Valid @RequestPart("dto") CreateStudyReqVo dto,
                                @RequestPart(value = "profileImage", required = false) MultipartFile profileImage,
                                @AuthenticationPrincipal CustomUserDetails userDetails) throws IOException {
        final StudyCreateResVo study = studyService.createStudy(dto, profileImage, userDetails.getUser());
        return DataResponseDto.of("study", study);
    }

    @Operation(summary = "스터디 간단한 정보 가져오기")
    @GetMapping
    public ResponseDto getStudySummary(@RequestParam Long studyId, @AuthenticationPrincipal CustomUserDetails userDetails) {
        final StudySummaryResVo studySummary = studyService.getStudySummary(studyId, userDetails.getUser());
        return DataResponseDto.of("studySummary", studySummary);
    }

    @Operation(summary = "스터디 목록 가져오기", description = "사용자가 속한 스터디의 목록을 가져온다 (홈화면)")
    @GetMapping("/list")
    public ResponseDto getStudies(@AuthenticationPrincipal CustomUserDetails userDetails) {
        final List<StudyInfoResVo> studyInfos = studyService.getStudies(userDetails.getUser());
        return DataResponseDto.of("studyInfos", studyInfos);
    }

    @Operation(summary = "스터디 편집하기", description = "스터디의 정보를 수정한다. 프로필 이미지가 변하지 않는 경우 null로 보내야 한다")
    @PatchMapping("/{studyId}")
    public ResponseDto editStudy(@PathVariable Long studyId,
                                 @Valid @RequestPart("dto") EditStudyReqVo dto,
                                 @RequestPart(value = "profileImage", required = false) MultipartFile profileImage,
                                 @AuthenticationPrincipal CustomUserDetails userDetails) throws IOException {
        final Long editedStudyId = studyService.editStudy(studyId, dto, profileImage, userDetails.getUser());
        return DataResponseDto.of("studyId", editedStudyId);
    }

    @Operation(summary = "스터디 초대코드 가져오기")
    @GetMapping("/{studyId}/inviteCode")
    public ResponseDto getInviteCode(@PathVariable Long studyId) {
        final String inviteCode = studyService.getInviteCode(studyId);
        return DataResponseDto.of("inviteCode", inviteCode);
    }
}