package ssu.groupstudy.domain.study.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.domain.Participants;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.repository.StudyPerUserRepository;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;


@Service
@AllArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class StudyCreateService {
    private final StudyRepository studyRepository;
    private final UserRepository userRepository;
    private final StudyPerUserRepository studyPerUserRepository;

    @Transactional
    public Study createStudy(CreateStudyRequest dto) {
        User hostUser = userRepository.findByUserId(dto.getHostUserId())
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        // 새로운 스터디 생성
        // TODO : 링크 생성의 책임을 어느 객체에게 어느 위치에 줘야할지 고민 (도메인 내에서 해결하면 좋을 거 같음)
        String inviteLink = generateInviteLink();
        String inviteQRCode = generateQrCode(inviteLink);
        Study newStudy = dto.toEntity(hostUser, inviteLink, inviteQRCode);
        newStudy = studyRepository.save(newStudy);

        // 유저 - 스터디 연결
        studyPerUserRepository.save(new Participants(hostUser, newStudy));

        return newStudy;
    }

    // TODO : 초대링크 생성 구현 여기다가 ㄴㄴㄴㄴ
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
