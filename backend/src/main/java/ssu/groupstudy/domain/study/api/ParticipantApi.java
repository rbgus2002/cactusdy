package ssu.groupstudy.domain.study.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.study.service.StudyInviteService;
import ssu.groupstudy.global.dto.ResponseDto;

@RestController
@RequestMapping("/study/participants")
@AllArgsConstructor
@Tag(name = "Study Participants", description = "스터디 참여자 API")
public class ParticipantApi {
    private final StudyInviteService studyInviteService;

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
}
