package ssu.groupstudy.domain.user.service;

import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.SignUpRequest;
import ssu.groupstudy.domain.user.exception.EmailExistsException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.error.ErrorCode;

@Service
@AllArgsConstructor
@Transactional
@Slf4j
public class UserSignUpService {
    private final UserRepository userRepository;

    public Long signUp(SignUpRequest dto){
        if(userRepository.existsByProfileEmail(dto.getEmail())){
            throw new EmailExistsException(ErrorCode.EMAIL_EXISTS_ALREADY.getMessage());
        }

        Long userId = userRepository.save(dto.toEntity()).getUserId();
        return userId;
    }
}
