package ssu.groupstudy.domain.study.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.response.ParticipantSummaryResponse;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.global.ResultCode;

import java.util.*;

@Service
@AllArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class ParticipantsService {
    private final StudyRepository studyRepository;

    public List<ParticipantSummaryResponse> getParticipantsProfileImageList(Long studyId) {
        Study study = studyRepository.findByStudyId(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));

        List<Participant> participantList = getParticipantListOrderByCreateDateAsc(study);

        List<ParticipantSummaryResponse> participantSummaryResponseList = new ArrayList<>();
        for(Participant participant : participantList){
            participantSummaryResponseList.add(ParticipantSummaryResponse.from(participant));
        }

        return participantSummaryResponseList;
    }

    private List<Participant> getParticipantListOrderByCreateDateAsc(Study study){
        List<Participant> participantList = new ArrayList<>(study.getParticipants().getParticipants());
        Collections.sort(participantList, new Comparator<Participant>() {
            @Override
            public int compare(Participant o1, Participant o2) {
                return o1.getCreateDate().compareTo(o2.getCreateDate());
            }
        });

        return participantList;
    }
}
