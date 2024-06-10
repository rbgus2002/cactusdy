package ssu.groupstudy.domain.feedback.service;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.feedback.entity.FeedbackEntity;
import ssu.groupstudy.domain.common.enums.FeedbackType;
import ssu.groupstudy.domain.feedback.dto.CreateNotionPageDto;
import ssu.groupstudy.api.user.vo.SendFeedbackReqVo;
import ssu.groupstudy.domain.feedback.repsoitory.FeedbackEntityRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.common.openfeign.NotionOpenFeign;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserFeedbackService {
    private final FeedbackEntityRepository feedbackEntityRepository;
    private final NotionOpenFeign notionOpenFeign;

    @Transactional
    public Long sendFeedback(FeedbackType type, SendFeedbackReqVo request, UserEntity writer) {
        FeedbackEntity feedback = FeedbackEntity.create(type, request.getTitle(), request.getContents(), writer);
        saveToNotion(feedback);
        return feedbackEntityRepository.save(feedback).getId();
    }

    private void saveToNotion(FeedbackEntity feedback) {
        CreateNotionPageDto dto = CreateNotionPageDto.create(feedback.getTitle(), feedback.getContents(), feedback.getWriter().getUserId(), feedback.getFeedbackType());
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String body = gson.toJson(dto);
        notionOpenFeign.createPage(body);
    }
}
