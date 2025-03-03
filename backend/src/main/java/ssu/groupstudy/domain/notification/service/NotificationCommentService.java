package ssu.groupstudy.domain.notification.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ssu.groupstudy.domain.common.enums.NotificationDataType;
import ssu.groupstudy.domain.common.enums.TopicCode;
import ssu.groupstudy.domain.notification.param.NotificationCommentParam;
import ssu.groupstudy.domain.notification.param.NotificationParam;

import java.util.Map;

import static ssu.groupstudy.domain.common.constants.NotificationConstants.*;
import static ssu.groupstudy.global.util.StringUtils.buildMessage;

@Service
@RequiredArgsConstructor
public class NotificationCommentService extends NotificationService {

    @Override
    protected void pushToFcm(NotificationParam param) {
        if (!(param instanceof NotificationCommentParam)) {
            throw new IllegalArgumentException("Invalid NotificationParam type");
        }
        NotificationCommentParam commentParam = (NotificationCommentParam) param;

        String title = buildMessage(COMMENT, commentParam.getCommentWriterNickname());
        String body = buildMessage(DOUBLE_QUOTE, commentParam.getCommentContents(), DOUBLE_QUOTE);

        Map<String, String> data = Map.of(
                DATA_TYPE, NotificationDataType.NOTICE.getValue(),
                NOTICE_ID, commentParam.getNoticeId().toString(),
                STUDY_ID, commentParam.getStudyId().toString()
        );
        fcmUtils.sendNotificationToTopic(title, body, TopicCode.NOTICE, commentParam.getNoticeId(), data);
    }
}
