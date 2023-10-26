package ssu.groupstudy.global.util;

import lombok.extern.slf4j.Slf4j;
import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Component
@Slf4j
public class MessageUtils {
    @Value("${coolsms.api.key}")
    private String apiKey;
    @Value("${coolsms.api.secret.key}")
    private String apiSecretKey;
    @Value("${coolsms.api.domain}")
    private String domain;
    @Value("${coolsms.api.fromNum}")
    private String fromNum;
    private DefaultMessageService messageService;

    @PostConstruct
    public void initialize() {
        this.messageService = NurigoApp.INSTANCE.initialize(apiKey, apiSecretKey, domain);
    }

    public void sendMessage(String phoneNumber, String content) {
        Message message = createMessage(phoneNumber, content);
        SingleMessageSentResponse response = messageService.sendOne(new SingleMessageSendingRequest(message));
        log.info("message : {}", response);
    }

    private Message createMessage(String phoneNumber, String contents) {
        Message message = initMessage(phoneNumber);
        message.setText(contents);
        return message;
    }

    private Message initMessage(String phoneNumber) {
        Message message = new Message();
        message.setFrom(fromNum);
        message.setTo(phoneNumber);
        return message;
    }
}
