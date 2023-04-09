package ssu.groupstudy.domain.user.service;

import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.SignUpRequest;
import ssu.groupstudy.domain.user.repository.UserRepository;

@Service
@AllArgsConstructor
@Transactional
public class UserSignUpService {
    private final UserRepository userRepository;

    public User signUp(SignUpRequest dto){
        User user = userRepository.save(dto.toEntity());
        return null;
    }
}
