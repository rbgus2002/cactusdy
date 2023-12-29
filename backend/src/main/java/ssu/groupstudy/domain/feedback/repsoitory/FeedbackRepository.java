package ssu.groupstudy.domain.feedback.repsoitory;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.feedback.domain.Feedback;

public interface FeedbackRepository extends JpaRepository<Feedback, Long> {
}
