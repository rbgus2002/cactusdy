package ssu.groupstudy.domain.round.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.round.repository.RoundParticipantRepository;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.global.ResultCode;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class RoundParticipantService {
    private final RoundParticipantRepository roundParticipantRepository;

    @Transactional
    public void updateStatusTag(Long id, String statusTag) {
        RoundParticipant roundParticipant = roundParticipantRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        roundParticipant.updateStatus(statusTag);
    }
}
