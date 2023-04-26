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
        User user = userRepository.findByUserId(dto.getUserId())
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        Study study = studyRepository.findByStudyId(dto.getStudyId())
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));

        // 이미 초대 되어있는지 검사
        if (studyPerUserRepository.existsByUserAndStudy(user, study)) {
            throw new InviteAlreadyExistsException(ResultCode.DUPLICATE_INVITE_INFO);
        }
        /*
        TODO : exist와 get 속도 차이 비교 후 유의미한 차이가 있으면 아래 코드와 같이 스프링 스럽게 유효성 검사 코드 변경
                this.memberRepository.findById(member.getId())
                .ifPresent(m -> {
                    throw new IllegalStateException("이미 존재하는 회원입니다.");
                });;
         */

        StudyPerUser studyPerUser = studyPerUserRepository.save(dto.toEntity(user, study));

        return studyPerUserRepository.save(studyPerUser).getUser().getUserId();
    }
}
