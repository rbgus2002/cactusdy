package ssu.groupstudy.domain.study.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.response.ParticipantSummary;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.global.ResultCode;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;

@Service
@AllArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class ParticipantsService {
    private final StudyRepository studyRepository;

    public List<ParticipantSummary> getParticipantsProfileImageList(Long studyId) {
        Study study = studyRepository.findByStudyId(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));

        Set<Participant> participantList = study.getParticipants().getParticipants();
        List<ParticipantSummary> participantSummaryList = new ArrayList<>();
        for(Participant participant : participantList){
            participantSummaryList.add(ParticipantSummary.from(participant));
        }
        // TODO : 가입순으로 오름차순 정렬

        return participantSummaryList;
    }
}
