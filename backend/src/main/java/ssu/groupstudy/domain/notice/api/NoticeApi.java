package ssu.groupstudy.domain.notice.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.domain.notice.dto.request.CreateNoticeRequest;
import ssu.groupstudy.domain.notice.dto.response.NoticeInfoResponse;
import ssu.groupstudy.domain.notice.dto.response.NoticeSummaries;
import ssu.groupstudy.domain.notice.dto.response.NoticeSummary;
import ssu.groupstudy.domain.notice.service.NoticeService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/notices")
@RequiredArgsConstructor
@Tag(name = "Notice", description = "공지사항 API")
public class NoticeApi {
    private final NoticeService noticeService;

    @Operation(summary = "새로운 공지사항 생성")
    @PostMapping
    public ResponseDto createNotice(@Valid @RequestBody CreateNoticeRequest dto, @AuthenticationPrincipal CustomUserDetails userDetails){
        Long noticeId = noticeService.createNotice(dto, userDetails.getUser());
        return DataResponseDto.of("noticeId", noticeId);
    }

    @Operation(summary = "id를 통한 공지사항 조회")
    @GetMapping
    public ResponseDto getNotice(@RequestParam Long noticeId, @AuthenticationPrincipal CustomUserDetails userDetails){
        NoticeInfoResponse noticeInfoResponse = noticeService.getNoticeById(noticeId, userDetails.getUser());
        return DataResponseDto.of("noticeInfo", noticeInfoResponse);
    }

    @Operation(summary = "공지사항 읽음/안읽음 체크")
    @PatchMapping("/check")
    public ResponseDto switchCheckNotice(@RequestParam Long noticeId, @AuthenticationPrincipal CustomUserDetails userDetails){
        final Character isChecked = noticeService.switchCheckNotice(noticeId, userDetails.getUser());
        return DataResponseDto.of("isChecked", isChecked);
    }

    @Operation(summary = "공지사항 목록 가져오기")
    @GetMapping("/list")
    public ResponseDto getNoticeSummaryList(@RequestParam Long studyId, @RequestParam int offset, @RequestParam int pageSize,
                                            @AuthenticationPrincipal CustomUserDetails userDetails){
        Pageable pageable = PageRequest.of(offset, pageSize);
        NoticeSummaries notices = noticeService.getNoticeSummaries(studyId, pageable, userDetails.getUser());
        return DataResponseDto.of("notices", notices);
    }

    @Operation(summary = "공지사항 목록 상위 3개 가져오기")
    @GetMapping("/list/limited")
    public ResponseDto getNoticeSummaryListLimit3(@RequestParam Long studyId){
        final List<NoticeSummary> noticeSummaryList = noticeService.getNoticeSummaryListLimit3(studyId);
        return DataResponseDto.of("noticeList", noticeSummaryList);
    }

    @Operation(summary = "공지사항 상단고정 상태 변경")
    @PatchMapping("/pin")
    public ResponseDto switchNoticePin(@RequestParam Long noticeId){
        final Character pinYn = noticeService.switchNoticePin(noticeId);
        return DataResponseDto.of("pinYn", pinYn);
    }

    @Operation(summary = "공지사항 읽은 사용자의 프로필 이미지 가져오기")
    @GetMapping("/users/images")
    public ResponseDto getCheckUserImageList(@RequestParam Long noticeId){
        final List<String> userImageList = noticeService.getCheckUserImageList(noticeId);
        return DataResponseDto.of("userImageList", userImageList);
    }

    @Operation(summary = "공지사항 삭제")
    @DeleteMapping
    public ResponseDto deleteNotice(@RequestParam Long noticeId){
        noticeService.delete(noticeId);
        return ResponseDto.success();
    }
}
