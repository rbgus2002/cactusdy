package ssu.groupstudy.domain.study.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.round.dto.request.AppointmentRequest;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.rule.domain.Rule;
import ssu.groupstudy.domain.rule.repository.RuleRepository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.task.entity.TaskType;
import ssu.groupstudy.domain.user.entity.UserEntity;
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


    @Transactional
    public void createExampleStudy(UserEntity user) {
        String inviteCode = studyInviteService.generateUniqueInviteCode();
        Study study = Study.init("2주 완성 토익 스터디 (예시)", "토익", Color.DEFAULT.getHex(), user, inviteCode);
        Study studyEntity = studyRepository.save(study);
        createExampleOthers(user, studyEntity);

        // [2024-06-10:최규현] TODO: default 이미지 추가 후 주석 해제
//        studyEntity.updatePicture("https://groupstudy-image.s3.ap-northeast-2.amazonaws.com/profile/study/12/4de854d8-80bd-40f5-a8fe-d60bd28de786");
    }

    private void createExampleOthers(UserEntity user, Study study) {
        createExampleNotice(user, study);
        createExampleRules(study);
        createExampleRounds(study);
    }

    private void createExampleNotice(UserEntity user, Study study) {
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
        Rule rule2 = Rule.create("매일 영단어 20개 암기", study);
        Rule rule3 = Rule.create("공부 시간 기록하고 공지사항에 인증하기", study);
        List<Rule> rules = List.of(rule1, rule2, rule3);
        ruleRepository.saveAll(rules);
    }

    private void createExampleRounds(Study study) {
        Round round1 = createRound(study, "스타벅스 동숭길 입구점", LocalDateTime.now().minusDays(1).withHour(15).withMinute(0));
        round1.updateDetail("스터디 첫날👏👏\n\n스타벅스 동숭길 입구점에서 만나요!");
        Round round2 = createRound(study, "카페 오가다", LocalDateTime.now().plusDays(7).withHour(12).withMinute(0));
        roundRepository.saveAll(List.of(round1, round2));
        createExampleTask(round1);
    }

    private Round createRound(Study study, String studyPlace, LocalDateTime studyTime) {
        AppointmentRequest appointment = AppointmentRequest.builder()
                .studyPlace(studyPlace)
                .studyTime(studyTime)
                .build();
        return appointment.toEntity(study);
    }

    private void createExampleTask(Round round) {
        List<RoundParticipant> roundParticipants = round.getRoundParticipants();
        roundParticipants.forEach(roundParticipant -> {
            roundParticipant.createTask("토익 RC에서 자주 나오는 핵심 어휘 50개 복습 및 문장 만들기", TaskType.PERSONAL);
            roundParticipant.createTask("RC Part7 5개 세트 연속 풀이 및 시간 관리 연습", TaskType.PERSONAL);
            roundParticipant.createTask("오늘의 토익 LC Part 복습: 최근 연습 세트 중 오답 선택한 문항 10개 재듣기 및 분석", TaskType.GROUP);
        });
    }

}
