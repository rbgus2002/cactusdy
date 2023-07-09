package ssu.groupstudy.domain.notice.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.dto.request.CreateNoticeRequest;
import ssu.groupstudy.domain.notice.dto.response.NoticeInfoResponse;
import ssu.groupstudy.domain.notice.dto.response.NoticeSummary;
import ssu.groupstudy.domain.notice.service.NoticeService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/notices")
@AllArgsConstructor
@Tag(name = "Notice", description = "공지사항 API")
public class NoticeApi {
    private final NoticeService noticeService;

    @Operation(summary = "새로운 공지사항 생성")
    @PostMapping("")
    public ResponseDto createNotice(@Valid @RequestBody CreateNoticeRequest dto){
        Long noticeId = noticeService.createNotice(dto);

        return DataResponseDto.of("noticeId", noticeId);
    }

    @Operation(summary = "id를 통한 공지사항 조회")
    @GetMapping("")
    public ResponseDto getNotice(@RequestParam Long noticeId){
        NoticeInfoResponse noticeInfoResponse = noticeService.getNoticeByNoticeId(noticeId);

        return DataResponseDto.of("noticeInfo", noticeInfoResponse);
    }

    @Operation(summary = "공지사항 읽음/안읽음 체크")
    @PatchMapping("/check")
    public ResponseDto switchCheckNotice(@RequestParam Long noticeId, @RequestParam Long userId){
        final Character isChecked = noticeService.switchCheckNotice(noticeId, userId);

        return DataResponseDto.of("isChecked", isChecked);
    }

    @Operation(summary = "공지사항 목록 가져오기")
    @GetMapping("/list")
    public ResponseDto getNoticeSummaryList(@RequestParam Long studyId){
        final List<NoticeSummary> noticeSummaryList = noticeService.getNoticeSummaryList(studyId);

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
}
