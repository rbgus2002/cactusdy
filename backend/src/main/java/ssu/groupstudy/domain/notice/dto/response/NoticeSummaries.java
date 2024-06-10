package ssu.groupstudy.domain.notice.dto.response;

import lombok.Getter;
import org.springframework.data.domain.Page;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;

import java.util.List;

@Getter
public class NoticeSummaries {
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
