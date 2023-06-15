package ssu.groupstudy.domain.notice.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.notice.dto.request.CreateNoticeRequest;
import ssu.groupstudy.domain.notice.service.NoticeService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;

@RestController
@RequestMapping("/notices")
@AllArgsConstructor
@Tag(name = "Notice", description = "공지사항 API")
public class NoticeApi {
    private final NoticeService noticeService;

    @Operation(summary = "새로운 공지사항 생성")
    @PostMapping("")
    public ResponseDto createNotice(@Valid @RequestBody CreateNoticeRequest dto){
        noticeService.createNotice(dto);

        return ResponseDto.success();
    }

    @Operation(summary = "공지사항 체크 이모지 클릭")
    @PostMapping("/check")
    public ResponseDto switchCheckNotice(@RequestParam Long noticeId, @RequestParam Long userId){
        final String isChecked = noticeService.switchCheckNotice(noticeId, userId);

        return DataResponseDto.of("isChecked", isChecked);
    }
}
