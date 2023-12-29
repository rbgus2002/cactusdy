package ssu.groupstudy.domain.feedback.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.feedback.domain.Feedback;
import ssu.groupstudy.domain.feedback.domain.FeedbackType;
import ssu.groupstudy.domain.feedback.dto.SendFeedbackRequest;
import ssu.groupstudy.domain.feedback.repsoitory.FeedbackRepository;
import ssu.groupstudy.domain.user.domain.User;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserFeedbackService {
    private final FeedbackRepository feedbackRepository;

    @Transactional
    public Long sendFeedback(FeedbackType type, SendFeedbackRequest request, User writer) {
        Feedback feedback = Feedback.create(type, request.getTitle(), request.getContents(), writer);
        return feedbackRepository.save(feedback).getId();
    }
}
