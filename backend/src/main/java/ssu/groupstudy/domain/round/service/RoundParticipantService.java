package ssu.groupstudy.domain.round.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.domain.common.enums.StatusTag;
import ssu.groupstudy.domain.round.exception.RoundParticipantNotFoundException;
import ssu.groupstudy.domain.round.repository.RoundParticipantRepository;

import static ssu.groupstudy.global.constant.ResultCode.ROUND_PARTICIPANT_NOT_FOUND;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class RoundParticipantService {
    private final RoundParticipantRepository roundParticipantRepository;

    @Transactional
    public void updateStatusTag(Long id, StatusTag statusTag) {
        RoundParticipantEntity roundParticipant = roundParticipantRepository.findById(id)
                .orElseThrow(() -> new RoundParticipantNotFoundException(ROUND_PARTICIPANT_NOT_FOUND));
        roundParticipant.updateStatus(statusTag);
    }
}
