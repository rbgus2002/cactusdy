package ssu.groupstudy.domain.study.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.notification.event.subscribe.StudyTopicSubscribeEvent;
import ssu.groupstudy.api.round.vo.AppointmentReqVo;
import ssu.groupstudy.domain.round.entity.RoundEntity;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.domain.round.repository.RoundParticipantEntityRepository;
import ssu.groupstudy.domain.round.repository.RoundEntityRepository;
import ssu.groupstudy.domain.rule.entity.RuleEntity;
import ssu.groupstudy.domain.rule.repository.RuleEntityRepository;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.api.study.vo.CreateStudyReqVo;
import ssu.groupstudy.api.study.vo.EditStudyReqVo;
import ssu.groupstudy.api.study.vo.StudyCreateResVo;
import ssu.groupstudy.api.study.vo.StudyInfoResVo;
import ssu.groupstudy.api.study.vo.StudySummaryResVo;
import ssu.groupstudy.domain.study.exception.CanNotCreateStudyException;
import ssu.groupstudy.domain.study.exception.ParticipantNotFoundException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantEntityRepository;
import ssu.groupstudy.domain.study.repository.StudyEntityRepository;
import ssu.groupstudy.domain.common.enums.TaskType;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;
import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.global.util.ImageManager;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;


@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class StudyService {
    private final StudyInviteService studyInviteService;
    private final UserEntityRepository userEntityRepository;
    private final StudyEntityRepository studyEntityRepository;
    private final ParticipantEntityRepository participantEntityRepository;
    private final RoundEntityRepository roundEntityRepository;
    private final RoundParticipantEntityRepository roundParticipantEntityRepository;
    private final RuleEntityRepository ruleEntityRepository;
    private final ImageManager imageManager;
    private final ApplicationEventPublisher eventPublisher;
    private final int PARTICIPATION_STUDY_LIMIT = 5;

    @Transactional
    public StudyCreateResVo createStudy(CreateStudyReqVo dto, MultipartFile image, UserEntity user) throws IOException {
        checkParticipatingStudyMoreThanLimit(user);
        String inviteCode = studyInviteService.generateUniqueInviteCode();
        StudyEntity study = studyEntityRepository.save(dto.toEntity(user, inviteCode));
        createDefaultOthers(study);

        imageManager.updateImage(study, image);
        eventPublisher.publishEvent(new StudyTopicSubscribeEvent(user, study));
        return StudyCreateResVo.of(study.getStudyId(), study.getInviteCode());
    }

    private void checkParticipatingStudyMoreThanLimit(UserEntity user) {
        if (participantEntityRepository.countParticipationStudy(user) >= PARTICIPATION_STUDY_LIMIT) {
            throw new CanNotCreateStudyException(ResultCode.USER_CAN_NOT_CREATE_STUDY);
        }
    }

    private void createDefaultOthers(StudyEntity study) {
        createDefaultRule(study);
        RoundEntity defaultRound = createDefaultRound(study);
        createDefaultTask(defaultRound);
    }

    private void createDefaultRule(StudyEntity study) {
        RuleEntity rule = RuleEntity.create("스터디 규칙을 추가해보세요!", study);
        ruleEntityRepository.save(rule);
    }

    private RoundEntity createDefaultRound(StudyEntity study) {
        AppointmentReqVo appointment = AppointmentReqVo.builder()
                .studyPlace(null)
                .studyTime(null)
                .build();
        return roundEntityRepository.save(appointment.toEntity(study));
    }

    private void createDefaultTask(RoundEntity defaultRound) {
        List<RoundParticipantEntity> roundParticipants = defaultRound.getRoundParticipants();
        roundParticipants.forEach(roundParticipant -> {
            roundParticipant.createTask(TaskType.PERSONAL.getDetail(), TaskType.PERSONAL);
            roundParticipant.createTask(TaskType.GROUP.getDetail(), TaskType.GROUP);
        });
    }

    public StudySummaryResVo getStudySummary(long studyId, UserEntity user) {
        StudyEntity study = studyEntityRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));
        ParticipantEntity participant = participantEntityRepository.findByUserAndStudy(user, study)
                .orElseThrow(() -> new ParticipantNotFoundException(ResultCode.PARTICIPANT_NOT_FOUND));
        return StudySummaryResVo.from(study, participant);
    }

    public List<StudyInfoResVo> getStudies(UserEntity user) {
        List<ParticipantEntity> participants = participantEntityRepository.findByUserOrderByCreateDate(user);
        return participants.stream()
                .map(this::createStudyInfo)
                .collect(Collectors.toList());
    }

    private StudyInfoResVo createStudyInfo(ParticipantEntity participant) {
        StudyEntity study = participant.getStudy();

        RoundEntity latestRound = roundEntityRepository.findLatestRound(study.getStudyId()).orElse(null);
        Long roundSeq = handleRoundSeq(study, latestRound);
        RoundParticipantEntity roundParticipant = roundParticipantEntityRepository.findByUserAndRound(participant.getUser(), latestRound).orElse(null);

        return StudyInfoResVo.of(participant, roundSeq, latestRound, roundParticipant);
    }

    private Long handleRoundSeq(StudyEntity study, RoundEntity round) {
        if (round == null) {
            return 0L;
        }
        if (round.isStudyTimeNull()) {
            // 스터디 약속 시간이 정해진 회차 + 1
            return roundEntityRepository.countByStudyTimeIsNotNull(study) + 1;
        } else {
            return roundEntityRepository.countByStudyTimeLessThanEqual(study, round.getStudyTime());
        }
    }

    @Transactional
    public Long editStudy(Long studyId, EditStudyReqVo dto, MultipartFile image, UserEntity user) throws IOException {
        StudyEntity study = studyEntityRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));
        ParticipantEntity participant = participantEntityRepository.findByUserAndStudy(user, study)
                .orElseThrow(() -> new ParticipantNotFoundException(ResultCode.PARTICIPANT_NOT_FOUND));
        UserEntity newHostUser = userEntityRepository.findById(dto.getHostUserId())
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        imageManager.updateImage(study, image);
        processEdit(dto, study, participant, newHostUser);

        return study.getStudyId();
    }

    private void processEdit(EditStudyReqVo dto, StudyEntity study, ParticipantEntity participant, UserEntity newHostUser) {
        study.edit(dto.getStudyName(), dto.getDetail(), newHostUser);
        participant.setColor(dto.getColor());
    }

    public String getInviteCode(Long studyId) {
        StudyEntity study = studyEntityRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));
        return study.getInviteCode();
    }
}
