package ssu.groupstudy.global.util;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.util.List;

@Component
@Slf4j
public class FcmUtils {
    @Value("${fcm.key.path}")
    private String FCM_PRIVATE_KEY_PATH;

    @Value("${fcm.key.scope}")
    private String FCM_SCOPE;

    @PostConstruct
    void initialize() {
        try {
            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.getApplicationDefault())
                    .build();
            processFirebaseInitialization(options);
        } catch (IOException e) {
            log.error(e.getMessage());
            throw new RuntimeException(e.getMessage());
        }
    }

    private void processFirebaseInitialization(FirebaseOptions options) {
        if (FirebaseApp.getApps().isEmpty()) {
            FirebaseApp.initializeApp(options);
            log.info("## processFirebaseInitialization : FirebaseApp initialized");
        }
    }

    public void sendNotificationByTokens(List<String> tokens, String title, String body) {
        MulticastMessage message = MulticastMessage.builder()
                .setNotification(Notification.builder()
                        .setTitle(title)
                        .setBody((body))
                        .build())
                .addAllTokens(tokens)
                .build();
        try {
            BatchResponse result = FirebaseMessaging.getInstance().sendEachForMulticast(message);
            log.info("## sendNotificationByTokens : success >> {}, fail >> {}", result.getSuccessCount(), result.getFailureCount()); // TODO : 함수 이름은 로그 내용에 제외 고려
        }catch (FirebaseMessagingException e){
            log.error("## sendNotificationByTokens : can not push >> {}", e.getMessage());
        }
    }
}
