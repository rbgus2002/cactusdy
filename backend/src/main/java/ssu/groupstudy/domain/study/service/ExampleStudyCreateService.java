package ssu.groupstudy.domain.study.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.domain.notice.repository.NoticeEntityRepository;
import ssu.groupstudy.api.round.vo.AppointmentReqVo;
import ssu.groupstudy.domain.round.entity.RoundEntity;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.domain.round.repository.RoundEntityRepository;
import ssu.groupstudy.domain.rule.entity.RuleEntity;
import ssu.groupstudy.domain.rule.repository.RuleEntityRepository;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.repository.StudyEntityRepository;
import ssu.groupstudy.domain.common.enums.TaskType;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.common.enums.ColorCode;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class ExampleStudyCreateService {
    private final StudyInviteService studyInviteService;
    private final NoticeEntityRepository noticeEntityRepository;
    private final StudyEntityRepository studyEntityRepository;
    private final RuleEntityRepository ruleEntityRepository;
    private final RoundEntityRepository roundEntityRepository;


    @Transactional
    public void createExampleStudy(UserEntity user) {
        String inviteCode = studyInviteService.generateUniqueInviteCode();
        StudyEntity studyEntity = studyEntityRepository.save(
                StudyEntity.init("2주 완성 토익 스터디 (예시)", "토익", ColorCode.DEFAULT.getHex(), user, inviteCode)
        );

        createExampleNotice(user, studyEntity);
        createExampleRules(studyEntity);
        createExampleRounds(studyEntity);

    }

    private void createExampleNotice(UserEntity user, StudyEntity study) {
        NoticeEntity notice = NoticeEntity.builder()
                .title("스터디 교재")
                .contents(
                        "안녕하세요, 여러분! \n\n다들 원하는 목표 점수를 달성하고\n원하는 바를 이루길 바라요🙏\n\n저희 다음주부터 있을 스터디의 교재로 해커스 교재를 이용해볼까 해요 !\n\n교재:해커스 토익 1000 제(RC / LC)\n\n다들 교재 꼭꼭 구매해 오세요!🥹"
                )
                .study(study)
                .writer(user)
                .build();
        noticeEntityRepository.save(notice);
    }

    private void createExampleRules(StudyEntity study) {
        RuleEntity rule1 = RuleEntity.create("지각하면 벌금 5000원", study);
        RuleEntity rule2 = RuleEntity.create("매일 영단어 20개 암기", study);
        RuleEntity rule3 = RuleEntity.create("공부 시간 기록하고 공지사항에 인증하기", study);
        List<RuleEntity> rules = List.of(rule1, rule2, rule3);
        ruleEntityRepository.saveAll(rules);
    }

    private void createExampleRounds(StudyEntity study) {
        RoundEntity round1 = createRound(study, "스타벅스 동숭길 입구점", LocalDateTime.now().minusDays(1).withHour(15).withMinute(0));
        round1.updateDetail("스터디 첫날👏👏\n\n스타벅스 동숭길 입구점에서 만나요!");
        RoundEntity round2 = createRound(study, "카페 오가다", LocalDateTime.now().plusDays(7).withHour(12).withMinute(0));
        roundEntityRepository.saveAll(List.of(round1, round2));
        createExampleTask(round1);
    }

    private RoundEntity createRound(StudyEntity study, String studyPlace, LocalDateTime studyTime) {
        AppointmentReqVo appointment = AppointmentReqVo.builder()
                .studyPlace(studyPlace)
                .studyTime(studyTime)
                .build();
        return appointment.toEntity(study);
    }

    private void createExampleTask(RoundEntity round) {
        List<RoundParticipantEntity> roundParticipants = round.getRoundParticipants();
        roundParticipants.forEach(roundParticipant -> {
            roundParticipant.createTask("토익 RC에서 자주 나오는 핵심 어휘 50개 복습 및 문장 만들기", TaskType.PERSONAL);
            roundParticipant.createTask("RC Part7 5개 세트 연속 풀이 및 시간 관리 연습", TaskType.PERSONAL);
            roundParticipant.createTask("오늘의 토익 LC Part 복습: 최근 연습 세트 중 오답 선택한 문항 10개 재듣기 및 분석", TaskType.GROUP);
        });
    }

}
