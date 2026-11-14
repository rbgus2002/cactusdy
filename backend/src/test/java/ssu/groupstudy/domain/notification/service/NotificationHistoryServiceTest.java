package ssu.groupstudy.domain.notification.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import ssu.groupstudy.api.notification.vo.NotificationHistoryPageResVo;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.common.enums.NotificationDataType;
import ssu.groupstudy.domain.notification.entity.NotificationHistoryEntity;
import ssu.groupstudy.domain.notification.repository.NotificationHistoryEntityRepository;
import ssu.groupstudy.domain.round.repository.RoundEntityRepository;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class NotificationHistoryServiceTest extends ServiceTest {
    @InjectMocks
    private NotificationHistoryService notificationHistoryService;
    @Mock
    private NotificationHistoryEntityRepository notificationHistoryEntityRepository;
    @Mock
    private UserEntityRepository userEntityRepository;
    @Mock
    private RoundEntityRepository roundEntityRepository;

    private NotificationHistoryEntity history(NotificationDataType type, String eventData) {
        return NotificationHistoryEntity.builder()
                .user(최규현).notificationDataType(type).title("t").message("m").eventData(eventData).isRead(false)
                .build();
    }

    @Test
    @DisplayName("회차 알림 내역의 roundSeq는 저장된 값(\"-\" 또는 누락) 대신 조회 시점의 회차 순번으로 채운다")
    void fillRoundSeq() {
        // given
        List<NotificationHistoryEntity> histories = List.of(
                history(NotificationDataType.ROUND, "{\"type\":\"round\",\"studyId\":\"3\",\"roundId\":\"1\",\"roundSeq\":\"-\"}"),
                history(NotificationDataType.ROUND, "{\"type\":\"round\",\"studyId\":\"3\",\"roundId\":\"1\",\"taskId\":\"9\"}"),
                history(NotificationDataType.ROUND, "{\"type\":\"round\",\"studyId\":\"3\",\"roundId\":\"404\",\"roundSeq\":\"-\"}"),
                history(NotificationDataType.NOTICE, "{\"type\":\"notice\",\"studyId\":\"3\",\"noticeId\":\"5\"}")
        );
        doReturn(Optional.of(최규현)).when(userEntityRepository).findById(any(Long.class));
        doReturn(new PageImpl<>(histories)).when(notificationHistoryEntityRepository).findByUserOrderByCreateDateDesc(any(), any());
        doReturn(Optional.of(회차1)).when(roundEntityRepository).findById(1L);
        doReturn(Optional.empty()).when(roundEntityRepository).findById(404L);
        doReturn(2L).when(roundEntityRepository).calculateRoundSeq(회차1);

        // when
        NotificationHistoryPageResVo response = notificationHistoryService.getNotificationHistories(1L, PageRequest.of(0, 10));

        // then
        List<Map<String, Object>> data = response.getContents().stream().map(c -> c.getData()).collect(java.util.stream.Collectors.toList());
        softly.assertThat(data.get(0).get("roundSeq")).isEqualTo("2");
        softly.assertThat(data.get(1).get("roundSeq")).isEqualTo("2");
        softly.assertThat(data.get(2).get("roundSeq")).isEqualTo("-"); // 삭제된 회차: 저장값 유지
        softly.assertThat(data.get(3)).doesNotContainKey("roundSeq");
    }
}
