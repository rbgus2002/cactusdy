package ssu.groupstudy.api.study.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.api.study.vo.ParticipantResVo;
import ssu.groupstudy.api.study.vo.ParticipantSummaryResVo;
import ssu.groupstudy.domain.study.service.ParticipantsService;
import ssu.groupstudy.domain.study.service.StudyInviteService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import java.util.List;

@RestController
@RequestMapping("/api/studies/participants")
@RequiredArgsConstructor
@Tag(name = "StudyEntity Participants", description = "스터디 참여자 API")
public class ParticipantController {
    private final StudyInviteService studyInviteService;
    private final ParticipantsService participantsService;

    @Operation(summary = "스터디 회원 초대")
    @PostMapping
    public ResponseDto inviteUser(@AuthenticationPrincipal CustomUserDetails userDetails, @RequestParam String inviteCode){
        final Long studyId = studyInviteService.inviteUser(userDetails.getUser(), inviteCode);
        return DataResponseDto.of("studyId", studyId);
    }

    @Operation(summary = "스터디 탈퇴하기")
    @DeleteMapping
    public ResponseDto leaveUser(@AuthenticationPrincipal CustomUserDetails userDetails, @RequestParam Long studyId){
        studyInviteService.leaveUser(userDetails.getUser(), studyId);
        return ResponseDto.success();
    }

    @Operation(summary = "스터디 회원 강퇴하기", description = "방장만 해당 기능을 이용할 수 있다")
    @DeleteMapping("/kick")
    public ResponseDto kickParticipant(@AuthenticationPrincipal CustomUserDetails userDetails, @RequestParam Long userId, @RequestParam Long studyId){
        participantsService.kickParticipant(userDetails.getUser(), userId, studyId);
        return ResponseDto.success();
    }

    @Operation(summary = "스터디에 소속된 사용자의 프로필 이미지를 모두 불러온다", description = "가입 시각을 기준으로 오름차순 정렬한다")
    @GetMapping("/summary")
    public ResponseDto getParticipantsProfileImageList(@RequestParam Long studyId){
        List<ParticipantSummaryResVo> participantSummaryResVoList = participantsService.getParticipantsProfileImageList(studyId);
        return DataResponseDto.of("participantSummaryList", participantSummaryResVoList);
    }

    @Operation(summary = "스터디 참여자 프로필 상세보기")
    @GetMapping
    public ResponseDto getParticipant(@RequestParam Long userId, @RequestParam Long studyId){
        ParticipantResVo participant = participantsService.getParticipant(userId, studyId);
        return DataResponseDto.of("participant", participant);
    }
}
