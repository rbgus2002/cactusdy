package ssu.groupstudy.domain.study.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.notification.domain.event.subscribe.StudyTopicSubscribeEvent;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.round.dto.request.AppointmentRequest;
import ssu.groupstudy.domain.round.repository.RoundParticipantRepository;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.response.StudyInfoResponse;
import ssu.groupstudy.domain.study.dto.response.StudySummaryResponse;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.exception.ParticipantNotFoundException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantRepository;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.task.domain.TaskType;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.constant.S3Code;
import ssu.groupstudy.global.util.S3Utils;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;


@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class StudyService {
    private final StudyRepository studyRepository;
    private final ParticipantRepository participantRepository;
    private final RoundRepository roundRepository;
    private final RoundParticipantRepository roundParticipantRepository;
    private final S3Utils s3Utils;
    private final ApplicationEventPublisher eventPublisher;

    @Transactional
    public Long createStudy(CreateStudyRequest dto, MultipartFile image, User user) throws IOException {
        Study study = studyRepository.save(dto.toEntity(user));
        handleUploadProfileImage(study, image);
        createDefaultRound(study);
        eventPublisher.publishEvent(new StudyTopicSubscribeEvent(user, study));
        return study.getStudyId();
    }

    private void createDefaultRound(Study study) {
        AppointmentRequest appointment = AppointmentRequest.builder()
                .studyPlace(null)
                .studyTime(null)
                .build();
        Round defaultRound = roundRepository.save(appointment.toEntity(study));
        createDefaultTask(defaultRound);
    }

    private void createDefaultTask(Round defaultRound) {
        List<RoundParticipant> roundParticipants = defaultRound.getRoundParticipants();
        roundParticipants.forEach(roundParticipant -> {
            roundParticipant.createTask(TaskType.PERSONAL.getDetail(), TaskType.PERSONAL);
            roundParticipant.createTask(TaskType.GROUP.getDetail(), TaskType.GROUP);
        });
    }

    private void handleUploadProfileImage(Study study, MultipartFile image) throws IOException {
        if (image == null) {
            return;
        }
        String imageUrl = s3Utils.uploadProfileImage(image, S3Code.STUDY_IMAGE, study.getStudyId());
        study.updatePicture(imageUrl);
    }

    public StudySummaryResponse getStudySummary(long studyId, User user) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));
        Participant participant = participantRepository.findByUserAndStudy(user, study)
                .orElseThrow(() -> new ParticipantNotFoundException(ResultCode.PARTICIPANT_NOT_FOUND));
        return StudySummaryResponse.from(study, participant);
    }

    public List<StudyInfoResponse> getStudies(User user) {
        List<Participant> participants = participantRepository.findByUserOrderByCreateDate(user);
        return participants.stream()
                .map(this::createStudyInfo)
                .collect(Collectors.toList());
    }

    private StudyInfoResponse createStudyInfo(Participant participant) {
        Study study = participant.getStudy();

        Round latestRound = roundRepository.findLatestRound(study.getStudyId()).orElse(null); // FIXME : 정상적으로 가져와지는데 LIMIT 1만 걸면 이상하게 studyTime이 null인 회차는 createDate 순으로 안가져옴
        Long roundSeq = handleRoundSeq(study, latestRound);
        RoundParticipant roundParticipant = roundParticipantRepository.findByUserAndRound(participant.getUser(), latestRound).orElse(null);

        return StudyInfoResponse.of(participant, roundSeq, latestRound, roundParticipant);
    }

    private Long handleRoundSeq(Study study, Round round) {
        if (round == null) {
            return 1L;
        }
        if (round.isStudyTimeNull()) {
            // 스터디 약속 시간이 정해진 회차 + 1
            return roundRepository.countByStudyTimeIsNotNull(study) + 1;
        } else {
            return roundRepository.countByStudyTimeLessThanEqual(study, round.getStudyTime());
        }
    }
}
