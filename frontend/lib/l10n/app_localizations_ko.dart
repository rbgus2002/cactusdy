// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get appName => '뜨끔';

  @override
  String get appDescriptionFront => '여러분의 스터디그룹, \n이제는 ';

  @override
  String get appDescriptionBack => ' 에서 \n관리해 드릴게요';

  @override
  String invitingMessage(Object invitingCode, Object studyName) {
    return '🌵[뜨끔] - 스터디 관리 앱\n\n\'과제 해오셨어요?\' (뜨끔!)\n\n스터디 관리를 \"뜨끔\"이 도와드릴게요.\n\'$studyName\'에 참여하세요!\n\n초대 코드: [$invitingCode]';
  }

  @override
  String get confirm => '확인';

  @override
  String get cancel => '취소';

  @override
  String get complete => '완료';

  @override
  String get close => '닫기';

  @override
  String get next => '다음';

  @override
  String get no => '아니요';

  @override
  String get editing => '수정';

  @override
  String get modify => '수정하기';

  @override
  String get delete => '삭제하기';

  @override
  String get doneModify => '수정 완료';

  @override
  String get themeMode => '화면 스타일';

  @override
  String get lightMode => '밝은 모드';

  @override
  String get darkMode => '어두운 모드';

  @override
  String get systemMode => '기기 설정과 같이';

  @override
  String get year => '년';

  @override
  String get month => '월';

  @override
  String get day => '일';

  @override
  String get hour => '시간';

  @override
  String get min => '분';

  @override
  String get sec => '초';

  @override
  String get date => '날짜';

  @override
  String get justNow => '방금';

  @override
  String get yesterday => '어제';

  @override
  String beforeOf(Object time) {
    return '$time전';
  }

  @override
  String get am => '오전';

  @override
  String get pm => '오후';

  @override
  String get undefined => '미정';

  @override
  String undefinedOf(Object target) {
    return '$target 미정';
  }

  @override
  String inputHint1(Object target) {
    return '$target을 입력해주세요.';
  }

  @override
  String inputHint2(Object target) {
    return '$target를 입력해주세요.';
  }

  @override
  String copyText1(Object target) {
    return '$target이 복사되었어요';
  }

  @override
  String copyText2(Object target) {
    return '$target가 복사되었어요';
  }

  @override
  String ensureToDo(Object action) {
    return '정말 $action하시겠어요?';
  }

  @override
  String successToDo(Object action) {
    return '성공적으로 $action했어요';
  }

  @override
  String willDo(Object action) {
    return '$action할래요';
  }

  @override
  String get ensureToResign => '정말 계정을 삭제하시나요?';

  @override
  String get resignWarning => '삭제 시 모든 데이터를\n다시는 복구할 수 없어요';

  @override
  String get unknownException => '알 수 없는 문제가 발생하였어요.';

  @override
  String get start => '시작하기';

  @override
  String get signIn => '로그인';

  @override
  String get signOut => '로그아웃';

  @override
  String get signUp => '가입하기';

  @override
  String get resign => '계정삭제';

  @override
  String get tokenExpired => '로그인 정보가 만료되었어요';

  @override
  String get alreadyHaveAnAccount => '이미 계정이 있나요?';

  @override
  String get successToSignUp => '가입이 완료되었어요.';

  @override
  String get phoneNumber => '휴대폰 번호';

  @override
  String get inputPhoneNumber => '휴대폰 번호를 입력해주세요';

  @override
  String get existPhoneNumber => '이미 가입된 휴대폰 번호에요.';

  @override
  String get password => '비밀번호';

  @override
  String get inputPassword => '비밀번호 입력해주세요';

  @override
  String get confirmPassword => '비밀번호 확인';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get resetPassword => '비밀번호 재설정';

  @override
  String get mismatchPassword => '비밀번호가 일치하지 않아요.';

  @override
  String get successToResetPassword => '비밀번호 변경이 완료되었어요.';

  @override
  String get receiveVerificationCode => '인증문자 받기';

  @override
  String get receiveVerificationCodeAgain => '인증문자 다시 받기';

  @override
  String get verificationCodeHint => '인증번호 6자리';

  @override
  String get sentVerificationCode => '인증번호가 문자로 전송되었어요.';

  @override
  String get wrongVerificationCode => '인증번호를 다시 입력해주세요.';

  @override
  String get setProfileAndNickname => '프로필과 닉네임을 설정해주세요';

  @override
  String get nameLengthHint => '2글자 이상 입력해주세요';

  @override
  String get nameHint => '이름은 한글과 영어만 입력 가능해요';

  @override
  String get name => '이름';

  @override
  String get nickname => '닉네임';

  @override
  String get statusMessage => '상태 메세지';

  @override
  String get statusMessageRecommend => '상태 메세지를 입력해 보세요!';

  @override
  String get editProfile => '프로필 편집';

  @override
  String get setting => '설정';

  @override
  String get profile => '프로필';

  @override
  String get viewProfile => '프로필 조회';

  @override
  String get study => '스터디';

  @override
  String get myStudy => '나의 스터디';

  @override
  String get addStudy => '스터디 추가';

  @override
  String get createStudy => '스터디 만들기';

  @override
  String get leaveStudy => '스터디 탈퇴';

  @override
  String get editStudy => '스터디 편집';

  @override
  String get joinedStudy => '활동 스터디';

  @override
  String get studyName => '스터디 이름';

  @override
  String get studyDetail => '상세 설명';

  @override
  String get studyColor => '스터디 색상';

  @override
  String get studyStart => '스터디 시작!';

  @override
  String get studyColorHint => '색상은 개인별로 설정이 가능해요';

  @override
  String get setStudyInfo => '스터디 정보를 설정해 주세요';

  @override
  String get startStudyWithFriend => '친구들과 스터디를 시작해 보세요';

  @override
  String get notWithUsNow => '지금은 함께하지 않아요...';

  @override
  String get participate => '참여하기';

  @override
  String get invitingCode => '초대코드';

  @override
  String get shareInvitingCode => '초대코드 공유';

  @override
  String get inputCode => '코드를 입력해 주세요';

  @override
  String get invitingCodeHint => '코드 6자리';

  @override
  String get shortInvitingCode => '초대코드 6자리를 전부 입력해주세요';

  @override
  String get host => '방장';

  @override
  String get hostDelegation => '방장 위임';

  @override
  String get hostDelegationHint => '다른 팀원에게 방장을 위임할 수 있어요';

  @override
  String ensureToDelegateHostTo(Object nickname) {
    return '$nickname에게\n방장을 위임할까요?';
  }

  @override
  String get member => '멤버';

  @override
  String get kick => '내보내기';

  @override
  String get kicking => '추방';

  @override
  String get participateByCode => '코드로 참여하기';

  @override
  String get leave => '탈퇴';

  @override
  String get stab => '찌르기';

  @override
  String stabUserAbout(Object nickname, Object prefix) {
    return '\'$nickname\'님을 $prefix콕 찔렀어요';
  }

  @override
  String stabTaskAbout(Object prefix) {
    return '과제를 $prefix콕 찔렀어요';
  }

  @override
  String get num => '번';

  @override
  String get even => '이나';

  @override
  String get rules => '규칙';

  @override
  String get writeRule => '규칙 작성';

  @override
  String ruleIsLimitedTo(Object count) {
    return '규칙은 최대 $count개 만들 수 있어요';
  }

  @override
  String get task => '과제';

  @override
  String get scheduled => '예정';

  @override
  String taskAchievementRateIs(Object rate) {
    return '과제를 $rate% 달성했어요';
  }

  @override
  String get achievement => '달성';

  @override
  String get count => '회';

  @override
  String get round => '회차';

  @override
  String get roundList => '회차 리스트';

  @override
  String get addRound => '회차 추가';

  @override
  String get deleteRound => '회차 삭제';

  @override
  String get record => '기록';

  @override
  String get recordHint => '스터디원 모두가 볼 수 있는 기록이에요';

  @override
  String roundLimitWarning(Object count) {
    return '회차는 최대 $count개만 생성할 수 있어요';
  }

  @override
  String get noti => '공지';

  @override
  String get notice => '공지사항';

  @override
  String get title => '제목';

  @override
  String get content => '내용';

  @override
  String get confirmDeleteNotice => '공지사항을 삭제하시겠어요?';

  @override
  String get tryToWriteNoti => '공지를 작성해보세요';

  @override
  String get comment => '댓글';

  @override
  String get writeReply => '답글쓰기';

  @override
  String get successToComment => '댓글을 작성했어요';

  @override
  String get confirmDeleteComment => '댓글을 삭제하시겠어요?';

  @override
  String get attendanceRate => '참석률';

  @override
  String get attendanceTag => '출석태그';

  @override
  String get attend => '참석';

  @override
  String get absent => '결석';

  @override
  String get late => '지각';

  @override
  String get place => '장소';

  @override
  String get time => '시간';

  @override
  String get feedback => '문의하기';

  @override
  String get send => '전송';

  @override
  String get feedbackType => '유형';

  @override
  String get feedbackTitle => '문의 제목';

  @override
  String get feedbackContent => '문의 내용';

  @override
  String get bug => '버그 제보';

  @override
  String get feat => '신규 기능';

  @override
  String get enhance => '기능 개선';

  @override
  String get etc => '기타';

  @override
  String get notificationCenter => '알림 센터';

  @override
  String get notificationReadAll => '전체 읽기';

  @override
  String get dummyForInsertion => '';
}
