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

    public void sendMessageTestToTopic(){
        Message message = Message.builder()
                .setNotification(Notification.builder()
                        .setTitle("topic TEST")
                        .setBody(("HERE"))
                        .build())
                .setTopic(TopicCode.ALL_USERS.getFormat())
                .build();

        try {
            String response = FirebaseMessaging.getInstance().send(message);
            log.info("## sendMessageTestToTopic : {}", response);
        } catch (FirebaseMessagingException e) {
            log.error("## sendMessageTestToTopic : {}", e.getMessage());
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
