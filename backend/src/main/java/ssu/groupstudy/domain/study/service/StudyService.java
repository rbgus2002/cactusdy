package ssu.groupstudy.domain.study.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.notification.event.subscribe.StudyTopicSubscribeEvent;
import ssu.groupstudy.domain.round.entity.RoundEntity;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.domain.round.dto.request.AppointmentRequest;
import ssu.groupstudy.domain.round.repository.RoundParticipantRepository;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.rule.entity.RuleEntity;
import ssu.groupstudy.domain.rule.repository.RuleRepository;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.dto.request.CreateStudyRequest;
import ssu.groupstudy.domain.study.dto.request.EditStudyRequest;
import ssu.groupstudy.domain.study.dto.response.StudyCreateResponse;
import ssu.groupstudy.domain.study.dto.response.StudyInfoResponse;
import ssu.groupstudy.domain.study.dto.response.StudySummaryResponse;
import ssu.groupstudy.domain.study.exception.CanNotCreateStudyException;
import ssu.groupstudy.domain.study.exception.ParticipantNotFoundException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantRepository;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.common.enums.TaskType;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.constant.ResultCode;
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
    private final UserRepository userRepository;
    private final StudyRepository studyRepository;
    private final ParticipantRepository participantRepository;
    private final RoundRepository roundRepository;
    private final RoundParticipantRepository roundParticipantRepository;
    private final RuleRepository ruleRepository;
    private final ImageManager imageManager;
    private final ApplicationEventPublisher eventPublisher;
    private final int PARTICIPATION_STUDY_LIMIT = 5;

    @Transactional
    public StudyCreateResponse createStudy(CreateStudyRequest dto, MultipartFile image, UserEntity user) throws IOException {
        checkParticipatingStudyMoreThanLimit(user);
        String inviteCode = studyInviteService.generateUniqueInviteCode();
        StudyEntity study = studyRepository.save(dto.toEntity(user, inviteCode));
        createDefaultOthers(study);

        imageManager.updateImage(study, image);
        eventPublisher.publishEvent(new StudyTopicSubscribeEvent(user, study));
        return StudyCreateResponse.of(study.getStudyId(), study.getInviteCode());
    }

    private void checkParticipatingStudyMoreThanLimit(UserEntity user) {
        if (participantRepository.countParticipationStudy(user) >= PARTICIPATION_STUDY_LIMIT) {
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
        ruleRepository.save(rule);
    }

    private RoundEntity createDefaultRound(StudyEntity study) {
        AppointmentRequest appointment = AppointmentRequest.builder()
                .studyPlace(null)
                .studyTime(null)
                .build();
        return roundRepository.save(appointment.toEntity(study));
    }

    private void createDefaultTask(RoundEntity defaultRound) {
        List<RoundParticipantEntity> roundParticipants = defaultRound.getRoundParticipants();
        roundParticipants.forEach(roundParticipant -> {
            roundParticipant.createTask(TaskType.PERSONAL.getDetail(), TaskType.PERSONAL);
            roundParticipant.createTask(TaskType.GROUP.getDetail(), TaskType.GROUP);
        });
    }

    public StudySummaryResponse getStudySummary(long studyId, UserEntity user) {
        StudyEntity study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));
        ParticipantEntity participant = participantRepository.findByUserAndStudy(user, study)
                .orElseThrow(() -> new ParticipantNotFoundException(ResultCode.PARTICIPANT_NOT_FOUND));
        return StudySummaryResponse.from(study, participant);
    }

    public List<StudyInfoResponse> getStudies(UserEntity user) {
        List<ParticipantEntity> participants = participantRepository.findByUserOrderByCreateDate(user);
        return participants.stream()
                .map(this::createStudyInfo)
                .collect(Collectors.toList());
    }

    private StudyInfoResponse createStudyInfo(ParticipantEntity participant) {
        StudyEntity study = participant.getStudy();

        RoundEntity latestRound = roundRepository.findLatestRound(study.getStudyId()).orElse(null);
        Long roundSeq = handleRoundSeq(study, latestRound);
        RoundParticipantEntity roundParticipant = roundParticipantRepository.findByUserAndRound(participant.getUser(), latestRound).orElse(null);

        return StudyInfoResponse.of(participant, roundSeq, latestRound, roundParticipant);
    }

    private Long handleRoundSeq(StudyEntity study, RoundEntity round) {
        if (round == null) {
            return 0L;
        }
        if (round.isStudyTimeNull()) {
            // 스터디 약속 시간이 정해진 회차 + 1
            return roundRepository.countByStudyTimeIsNotNull(study) + 1;
        } else {
            return roundRepository.countByStudyTimeLessThanEqual(study, round.getStudyTime());
        }
    }

    @Transactional
    public Long editStudy(Long studyId, EditStudyRequest dto, MultipartFile image, UserEntity user) throws IOException {
        StudyEntity study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));
        ParticipantEntity participant = participantRepository.findByUserAndStudy(user, study)
                .orElseThrow(() -> new ParticipantNotFoundException(ResultCode.PARTICIPANT_NOT_FOUND));
        UserEntity newHostUser = userRepository.findById(dto.getHostUserId())
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        imageManager.updateImage(study, image);
        processEdit(dto, study, participant, newHostUser);

        return study.getStudyId();
    }

    private void processEdit(EditStudyRequest dto, StudyEntity study, ParticipantEntity participant, UserEntity newHostUser) {
        study.edit(dto.getStudyName(), dto.getDetail(), newHostUser);
        participant.setColor(dto.getColor());
    }

    public String getInviteCode(Long studyId) {
        StudyEntity study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));
        return study.getInviteCode();
    }
}
