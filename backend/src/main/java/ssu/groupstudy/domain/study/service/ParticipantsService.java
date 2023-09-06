package ssu.groupstudy.domain.study.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.response.ParticipantSummaryResponse;
import ssu.groupstudy.domain.study.exception.ParticipantNotFoundException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantRepository;
import ssu.groupstudy.domain.study.repository.StudyRepository;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import static ssu.groupstudy.global.ResultCode.*;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class ParticipantsService {
    private final StudyRepository studyRepository;
    private final ParticipantRepository participantRepository;

    // TODO : userId가 아닌 userStudyId를 보내주어야 하는 것이 아닌가?
    public List<ParticipantSummaryResponse> getParticipantsProfileImageList(Long studyId) {
        Study study = studyRepository.findByStudyId(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));

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

    @Transactional
    public void modifyColor(Long participantId, String colorCode){
        Participant participant = participantRepository.findById(participantId)
                .orElseThrow(() -> new ParticipantNotFoundException(PARTICIPANT_NOT_FOUND));
        participant.setColor(colorCode);
    }
}
