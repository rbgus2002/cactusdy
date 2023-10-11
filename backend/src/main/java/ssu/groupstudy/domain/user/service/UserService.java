package ssu.groupstudy.domain.user.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.StatusMessageRequest;
import ssu.groupstudy.domain.user.repository.UserRepository;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class UserService {
    private final UserRepository userRepository;

    @Transactional
    public void updateStatusMessage(User user, StatusMessageRequest request) {
        user.setStatusMessage(request.getStatusMessage());
        userRepository.save(user);
    }
}
