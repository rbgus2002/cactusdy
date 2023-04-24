package ssu.groupstudy.domain.study.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.domain.StudyPerUser;
import ssu.groupstudy.domain.study.dto.reuqest.RegisterStudyRequest;
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
public class StudyCreateService {
    private final StudyRepository studyRepository;
    private final UserRepository userRepository;
    private final StudyPerUserRepository studyPerUserRepository;

    public Study createNewStudy(RegisterStudyRequest dto) {
        // TODO : throwOr 뭐 이런걸로 한 줄로 바꾸기
        Optional<User> hostUser = userRepository.getUserByUserId(dto.getHostUserId());
        if (hostUser.isEmpty()) {
            throw new UserNotFoundException(ResultCode.USER_NOT_FOUND);
        }

        // 새로운 스터디 생성
        Study newStudy = dto.toEntityWithUser(hostUser.get());
        newStudy.setInviteLink(generateInviteLink());
        newStudy.setInviteQrCode(generateQrCode(newStudy.getInviteLink()));
        newStudy = studyRepository.save(newStudy);

        // 유저 - 스터디 연결
        studyPerUserRepository.save(new StudyPerUser(hostUser.get(), newStudy));

        return newStudy;
    }

    // TODO : 초대링크 생성 구현
    private String generateInviteLink() {
        return "";
    }


    /*
    TODO
     message 담기는 QR 코드 생성 구현
     QR 코드 포함 이미지들은 S3에 저장하는 게 적합한가 판단 후 구현 (플러터에서 어떤 형식으로 서버를 향해 이미지를 보내는가에 관함)
     */
    private String generateQrCode(String message) {
        return "";
    }

}
