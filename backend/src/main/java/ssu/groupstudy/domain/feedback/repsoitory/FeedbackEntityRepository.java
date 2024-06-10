package ssu.groupstudy.domain.feedback.repsoitory;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.feedback.entity.FeedbackEntity;

public interface FeedbackEntityRepository extends JpaRepository<FeedbackEntity, Long> {
}
