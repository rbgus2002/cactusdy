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

@Component
@Slf4j
public class FcmUtils {
    // TODO : 추후 테스트 코드 작성
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

    // TODO : 해당 알림 클릭하면 어느 화면으로 이동할 것인가 생각하고 putData 고려
    public void sendNotificationByTokens(List<String> tokens, String title, String body) {
        MulticastMessage message = MulticastMessage.builder()
                .setNotification(Notification.builder()
                        .setTitle(title)
                        .setBody((body))
                        .build())
                .addAllTokens(tokens)
                .build();
        try {
            BatchResponse response = FirebaseMessaging.getInstance().sendEachForMulticast(message);
            log.info("## sendNotificationByTokens : success >> {}, fail >> {}", response.getSuccessCount(), response.getFailureCount());
        }catch (FirebaseMessagingException e){
            log.error("## sendNotificationByTokens : can not push >> {}", e.getMessage());
        }
    }

    // TODO : 비동기 처리
    public void sendNotificationToTopic(String title, String body, TopicCode code, Long id){
        String topic = TopicCode.handleTopicString(code, id);
        Message message = Message.builder()
                .putData("id", String.valueOf(id))
                .setNotification(Notification.builder()
                        .setTitle(title)
                        .setBody(body)
                        .build())
                .setTopic(topic)
                .build();

        try {
            String response = FirebaseMessaging.getInstance().send(message);
            log.info("## sendNotificationToTopic : {}", response);
        } catch (FirebaseMessagingException e) {
            log.error("## sendNotificationToTopic : {}", e.getMessage());
        }

    }

    // TODO : 비동기 처리
    public void subscribeTopicFor(List<String> tokens, TopicCode code, Long id) {
        String topic = TopicCode.handleTopicString(code, id);
        try {
            TopicManagementResponse response = FirebaseMessaging.getInstance().subscribeToTopic(tokens, topic);
            log.info("## subscribe {} : success >> {}, fail >> {}", topic, response.getSuccessCount(), response.getFailureCount());
        } catch (FirebaseMessagingException e) {
            log.error("## subscribeTopicFor : {}", e.getMessage());
        }
    }
}
