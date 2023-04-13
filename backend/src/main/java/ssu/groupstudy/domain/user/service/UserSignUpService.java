package ssu.groupstudy.domain.user.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.exception.EmailExistsException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.error.ResultCode;

@Service
@AllArgsConstructor
@Transactional
@Slf4j
public class UserSignUpService {
    private final UserRepository userRepository;

    public User signUp(SignUpRequest dto){
        if(userRepository.existsByProfileEmail(dto.getEmail())){
            throw new EmailExistsException(ResultCode.DUPLICATE_EMAIL_ERROR);
        }

        User user = userRepository.save(dto.toEntity());
        return user;
    }
}
