package ssu.groupstudy.domain.study.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.domain.StudyPerUser;
import ssu.groupstudy.domain.study.dto.reuqest.InviteUserRequest;
import ssu.groupstudy.domain.study.exception.InviteAlreadyExistsException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyPerUserRepository;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

import java.util.Optional;

@Service
@AllArgsConstructor
@Transactional
@Slf4j
public class StudyInviteService {
    private final StudyPerUserRepository studyPerUserRepository;
    private final UserRepository userRepository;
    private final StudyRepository studyRepository;

    public Long inviteUserToStudy(InviteUserRequest dto) {
        Optional<User> user = userRepository.getUserByUserId(dto.getUserId());
        if (user.isEmpty()) {
            throw new UserNotFoundException(ResultCode.USER_NOT_FOUND);
        }

        Optional<Study> study = studyRepository.getStudyByStudyId(dto.getStudyId());
        if (study.isEmpty()) {
            throw new StudyNotFoundException(ResultCode.USER_NOT_FOUND);
        }

        if(studyPerUserRepository.existsByUserAndStudy(user.get(), study.get())){
            throw new InviteAlreadyExistsException(ResultCode.DUPLICATE_INVITE_INFO);
        }

        StudyPerUser studyPerUser = studyPerUserRepository.save(dto.toEntity(user.get(), study.get()));
        return studyPerUserRepository.save(studyPerUser).getUser().getUserId();
    }
}
