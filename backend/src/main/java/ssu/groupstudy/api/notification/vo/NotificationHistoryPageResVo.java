package ssu.groupstudy.api.notification.vo;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;
import ssu.groupstudy.domain.notification.entity.NotificationHistoryEntity;

import java.util.List;
import java.util.stream.Collectors;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class NotificationHistoryPageResVo {
    
    private List<NotificationHistoryResVo> contents;
    private PageableVo pageable;
    
    public static NotificationHistoryPageResVo of(Page<NotificationHistoryEntity> page) {
        List<NotificationHistoryResVo> content = page.getContent().stream()
                .map(NotificationHistoryResVo::of)
                .collect(Collectors.toList());
        
        PageableVo pageable = PageableVo.of(page);
        
        return new NotificationHistoryPageResVo(content, pageable);
    }
    
    @Getter
    @NoArgsConstructor(access = AccessLevel.PROTECTED)
    @AllArgsConstructor(access = AccessLevel.PRIVATE)
    public static class PageableVo {
        private int page;
        private int size;
        private long totalElements;
        private int totalPages;
        
        public static PageableVo of(Page<?> page) {
            return new PageableVo(
                page.getNumber(),
                page.getSize(),
                page.getTotalElements(),
                page.getTotalPages()
            );
        }
    }
}