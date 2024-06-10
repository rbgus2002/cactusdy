package ssu.groupstudy.domain.notice.param;

import lombok.Getter;
import org.springframework.data.domain.Page;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;

import java.util.List;

@Getter
public class NoticeSummaries { // [2024-06-10:최규현] TODO: param 변경
    private Long totalElements;
    private int totalPages;
    private List<NoticeSummary> noticeList;

    private NoticeSummaries(Page<NoticeEntity> noticePage, List<NoticeSummary> notices) {
        this.totalElements = noticePage.getTotalElements();
        this.totalPages = noticePage.getTotalPages();
        this.noticeList = notices;
    }

    public static NoticeSummaries of(Page<NoticeEntity> noticePage, List<NoticeSummary> notices){
        return new NoticeSummaries(noticePage, notices);
    }
}
