package ssu.groupstudy.domain.study.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.study.dto.response.ParticipantSummaryResponse;
import ssu.groupstudy.domain.study.service.ParticipantsService;
import ssu.groupstudy.domain.study.service.StudyInviteService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import java.util.List;

@RestController
@RequestMapping("/studies/participants")
@RequiredArgsConstructor
@Tag(name = "Study Participants", description = "스터디 참여자 API")
public class ParticipantApi {
    private final StudyInviteService studyInviteService;
    private final ParticipantsService participantsService;

    @Operation(summary = "스터디에 회원 초대")
    @PostMapping("/invite")
    public ResponseDto inviteUser(@RequestParam Long userId, @RequestParam Long studyId){
        studyInviteService.inviteUser(userId, studyId);

        return ResponseDto.success();
    }

    @Operation(summary = "스터디에서 회원 탈퇴")
    @DeleteMapping("/invite")
    public ResponseDto leaveUser(@RequestParam Long userId, @RequestParam Long studyId){
        studyInviteService.leaveUser(userId, studyId);

        return ResponseDto.success();
    }

    @Operation(summary = "스터디에 소속된 사용자의 프로필 이미지를 모두 불러온다", description = "가입 시각을 기준으로 오름차순 정렬한다")
    @GetMapping("/summary")
    public ResponseDto getParticipantsProfileImageList(@RequestParam Long studyId){
        List<ParticipantSummaryResponse> participantSummaryResponseList = participantsService.getParticipantsProfileImageList(studyId);

        return DataResponseDto.of("participantSummaryList", participantSummaryResponseList);
    }

}
