package ssu.groupstudy.domain.study.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.dto.request.AppointmentRequest;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.rule.domain.Rule;
import ssu.groupstudy.domain.rule.repository.RuleRepository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.constant.Color;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class ExampleStudyCreateService {
    private final StudyInviteService studyInviteService;
    private final NoticeRepository noticeRepository;
    private final StudyRepository studyRepository;
    private final RuleRepository ruleRepository;
    private final RoundRepository roundRepository;
    private final ApplicationEventPublisher eventPublisher;

    public void createExampleStudy(User user) {
        String inviteCode = studyInviteService.generateUniqueInviteCode();
        Study study = Study.init("토익 스터디 (예시)", "토익", Color.DEFAULT.getHex(), user, inviteCode);
        Study studyEntity = studyRepository.save(study);
        createExampleOthers(user, studyEntity);

        studyEntity.updatePicture("https://groupstudy-image.s3.ap-northeast-2.amazonaws.com/profile/study/12/4de854d8-80bd-40f5-a8fe-d60bd28de786");
    }

    private void createExampleOthers(User user, Study study) {
        createExampleNotice(user, study);
        createExampleRules(study);
        createExampleRounds(study);
    }

    private void createExampleNotice(User user, Study study) {
        Notice notice = Notice.builder()
                .title("스터디 교재")
                .contents(
                        "안녕하세요, 여러분! \n\n다들 원하는 목표 점수를 달성하고\n원하는 바를 이루길 바라요🙏\n\n저희 다음주부터 있을 스터디의 교재로 해커스 교재를 이용해볼까 해요 !\n\n교재:해커스 토익 1000 제(RC / LC)\n\n다들 교재 꼭꼭 구매해 오세요!🥹"
                )
                .study(study)
                .writer(user)
                .build();
        noticeRepository.save(notice);
    }

    private void createExampleRules(Study study) {
        Rule rule1 = Rule.create("지각하면 벌금 5000원", study);
        Rule rule2 = Rule.create("매일 영단어 20개 외우고 인증 사진 올리기", study);
        Rule rule3 = Rule.create("공부 시간 기록하고 인증하기", study);
        Rule rule4 = Rule.create("(예시 스터디에는 알림이 오지 않아요)", study);
        List<Rule> rules = List.of(rule1, rule2, rule3, rule4);
        ruleRepository.saveAll(rules);
    }

    private void createExampleRounds(Study study) {
        Round round1 = createRoundEntity(study, "스타벅스 동숭길 입구점", LocalDateTime.now().minusDays(1).withHour(15));
        round1.updateDetail("스터디 첫날👏👏\n\n스타벅스 동숭길 입구점에서 만나요!");
        Round round2 = createRoundEntity(study, "카페 오가다", LocalDateTime.now().plusDays(7).withHour(12));
        List<Round> rounds = List.of(round1, round2);
        roundRepository.saveAll(rounds);
        createExampleTask(round1);
    }

    private void createExampleTask(Round round) {

    }

    private Round createRoundEntity(Study study, String studyPlace, LocalDateTime studyTime) {
        return AppointmentRequest.builder()
                .studyPlace(studyPlace)
                .studyTime(studyTime)
                .build()
                .toEntity(study);
    }

}
