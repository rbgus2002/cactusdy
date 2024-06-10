package ssu.groupstudy.api.notice.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.api.notice.vo.CreateNoticeReqVo;
import ssu.groupstudy.api.notice.vo.EditNoticeReqVo;
import ssu.groupstudy.api.notice.vo.NoticeInfoResVo;
import ssu.groupstudy.domain.notice.param.NoticeSummaries;
import ssu.groupstudy.domain.notice.param.NoticeSummary;
import ssu.groupstudy.domain.notice.service.NoticeService;
import ssu.groupstudy.api.common.vo.DataResVo;
import ssu.groupstudy.api.common.vo.ResVo;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/notices")
@RequiredArgsConstructor
@Tag(name = "NoticeEntity", description = "공지사항 API")
public class NoticeController {
    private final NoticeService noticeService;

    @Operation(summary = "id를 통한 공지사항 조회")
    @GetMapping
    public ResVo getNotice(@RequestParam Long noticeId, @AuthenticationPrincipal CustomUserDetails userDetails){
        NoticeInfoResVo noticeInfoResVo = noticeService.getNoticeById(noticeId, userDetails.getUser());
        return DataResVo.of("noticeInfo", noticeInfoResVo);
    }

    @Operation(summary = "새로운 공지사항 생성")
    @PostMapping
    public ResVo createNotice(@Valid @RequestBody CreateNoticeReqVo dto, @AuthenticationPrincipal CustomUserDetails userDetails){
        NoticeInfoResVo noticeInfoResVo = noticeService.createNotice(dto, userDetails.getUser());
        return DataResVo.of("noticeInfo", noticeInfoResVo);
    }

    @Operation(summary = "공지사항 수정")
    @PatchMapping
    public ResVo updateNotice(@RequestParam Long noticeId, @Valid @RequestBody EditNoticeReqVo dto){
        noticeService.updateNotice(noticeId, dto);
        return ResVo.success();
    }

    @Operation(summary = "공지사항 삭제")
    @DeleteMapping
    public ResVo deleteNotice(@RequestParam Long noticeId){
        noticeService.delete(noticeId);
        return ResVo.success();
    }

    @Operation(summary = "공지사항 읽음/안읽음 체크")
    @PatchMapping("/check")
    public ResVo switchCheckNotice(@RequestParam Long noticeId, @AuthenticationPrincipal CustomUserDetails userDetails){
        final Character isChecked = noticeService.switchCheckNotice(noticeId, userDetails.getUser());
        return DataResVo.of("isChecked", isChecked);
    }

    @Operation(summary = "공지사항 목록 가져오기")
    @GetMapping("/list")
    public ResVo getNoticeSummaryList(@RequestParam Long studyId, @RequestParam int offset, @RequestParam int pageSize,
                                      @AuthenticationPrincipal CustomUserDetails userDetails){
        Pageable pageable = PageRequest.of(offset, pageSize);
        NoticeSummaries notices = noticeService.getNoticeSummaries(studyId, pageable, userDetails.getUser());
        return DataResVo.of("notices", notices);
    }

    @Operation(summary = "공지사항 목록 상위 3개 가져오기")
    @GetMapping("/list/limited")
    public ResVo getNoticeSummaryListLimit3(@RequestParam Long studyId){
        final List<NoticeSummary> noticeSummaryList = noticeService.getNoticeSummaryListLimit3(studyId);
        return DataResVo.of("noticeList", noticeSummaryList);
    }

    @Operation(summary = "공지사항 상단고정 상태 변경")
    @PatchMapping("/pin")
    public ResVo switchNoticePin(@RequestParam Long noticeId){
        final Character pinYn = noticeService.switchNoticePin(noticeId);
        return DataResVo.of("pinYn", pinYn);
    }

    @Operation(summary = "공지사항 읽은 사용자의 프로필 이미지 가져오기")
    @GetMapping("/users/images")
    public ResVo getCheckUserImageList(@RequestParam Long noticeId){
        final List<String> userImageList = noticeService.getCheckUserImageList(noticeId);
        return DataResVo.of("userImageList", userImageList);
    }
}
