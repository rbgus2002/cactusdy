package ssu.groupstudy.global.util;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import ssu.groupstudy.domain.notification.domain.TopicCode;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@Component
@Slf4j
public class FcmUtils {
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

    public void sendNotificationByTokens(List<String> tokens, String title, String body, Map<String, String> data) {
        log.info("## sendNotificationByTokens : title = {}, body = {}", title, body);
        MulticastMessage message = MulticastMessage.builder()
                .setNotification(Notification.builder()
                        .setTitle(title)
                        .setBody((body))
                        .build())
                .putAllData(data)
                .addAllTokens(tokens)
                .build();
        FirebaseMessaging.getInstance().sendEachForMulticastAsync(message);
    }

    // TODO : 직접 @Async로 구현하고 실패하는 토큰의 경우 delete 하도록 구현
    public void sendNotificationToTopic(String title, String body, TopicCode code, Long id, Map<String, String> data){
        log.info("## sendNotificationToTopic : title = {}, body = {}", title, body);
        String topic = TopicCode.handleTopicString(code, id);
        Message message = Message.builder()
                .setNotification(Notification.builder()
                        .setTitle(title)
                        .setBody(body)
                        .build())
                .putAllData(data)
                .setTopic(topic)
                .build();
        FirebaseMessaging.getInstance().sendAsync(message);
    }

    public void subscribeTopicFor(List<String> tokens, TopicCode code, Long id) {
        String topic = TopicCode.handleTopicString(code, id);
        FirebaseMessaging.getInstance().subscribeToTopicAsync(tokens, topic);
    }

    public void unsubscribeTopicFor(List<String> tokens, TopicCode code, Long id) {
        String topic = TopicCode.handleTopicString(code, id);
        FirebaseMessaging.getInstance().unsubscribeFromTopicAsync(tokens, topic);
    }
}
