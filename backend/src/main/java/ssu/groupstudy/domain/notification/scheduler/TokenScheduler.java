package ssu.groupstudy.domain.notification.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import ssu.groupstudy.domain.notification.domain.FcmToken;
import ssu.groupstudy.domain.notification.repository.FcmTokenRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class TokenScheduler {
    private final FcmTokenRepository fcmTokenRepository;

    @Scheduled(cron = "0 0 2 10,25 * ?", zone = "Asia/Seoul")
    public void deleteExpiredToken() {
        log.info("deleteExpiredToken() : start {}", LocalDateTime.now());
        List<FcmToken> expiredFcmTokens = fcmTokenRepository.findAll().stream()
                .filter(FcmToken::isExpired)
                .collect(Collectors.toList());
        fcmTokenRepository.deleteAllInBatch(expiredFcmTokens);
    }
}
