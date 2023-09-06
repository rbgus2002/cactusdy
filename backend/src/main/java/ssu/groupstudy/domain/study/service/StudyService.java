package ssu.groupstudy.domain.study.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.response.StudySummaryResponse;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;


@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class StudyService {
    private final StudyRepository studyRepository;
    private final UserRepository userRepository;

    @Transactional
    public Long createStudy(CreateStudyRequest dto) {
        User hostUser = userRepository.findByUserId(dto.getHostUserId())
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        return studyRepository.save(dto.toEntity(hostUser)).getStudyId();
    }

    public StudySummaryResponse getStudySummary(long studyId) {
        Study study = studyRepository.findByStudyId(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));

        return StudySummaryResponse.from(study);
    }
}
