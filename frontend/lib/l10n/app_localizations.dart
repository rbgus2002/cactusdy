import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ko')
  ];

  /// No description provided for @helloWorld.
  ///
  /// In ko, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @appName.
  ///
  /// In ko, this message translates to:
  /// **'뜨끔'**
  String get appName;

  /// No description provided for @appDescriptionFront.
  ///
  /// In ko, this message translates to:
  /// **'여러분의 스터디그룹, \n이제는 '**
  String get appDescriptionFront;

  /// No description provided for @appDescriptionBack.
  ///
  /// In ko, this message translates to:
  /// **' 에서 \n관리해 드릴게요'**
  String get appDescriptionBack;

  /// No description provided for @invitingMessage.
  ///
  /// In ko, this message translates to:
  /// **'🌵[뜨끔] - 스터디 관리 앱\n\n\'과제 해오셨어요?\' (뜨끔!)\n\n스터디 관리를 \"뜨끔\"이 도와드릴게요.\n\'{studyName}\'에 참여하세요!\n\n초대 코드: [{invitingCode}]'**
  String invitingMessage(Object invitingCode, Object studyName);

  /// No description provided for @confirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @complete.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get complete;

  /// No description provided for @close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get close;

  /// No description provided for @next.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get next;

  /// No description provided for @no.
  ///
  /// In ko, this message translates to:
  /// **'아니요'**
  String get no;

  /// No description provided for @editing.
  ///
  /// In ko, this message translates to:
  /// **'수정'**
  String get editing;

  /// No description provided for @modify.
  ///
  /// In ko, this message translates to:
  /// **'수정하기'**
  String get modify;

  /// No description provided for @delete.
  ///
  /// In ko, this message translates to:
  /// **'삭제하기'**
  String get delete;

  /// No description provided for @doneModify.
  ///
  /// In ko, this message translates to:
  /// **'수정 완료'**
  String get doneModify;

  /// No description provided for @themeMode.
  ///
  /// In ko, this message translates to:
  /// **'화면 스타일'**
  String get themeMode;

  /// No description provided for @lightMode.
  ///
  /// In ko, this message translates to:
  /// **'밝은 모드'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In ko, this message translates to:
  /// **'어두운 모드'**
  String get darkMode;

  /// No description provided for @systemMode.
  ///
  /// In ko, this message translates to:
  /// **'기기 설정과 같이'**
  String get systemMode;

  /// No description provided for @year.
  ///
  /// In ko, this message translates to:
  /// **'년'**
  String get year;

  /// No description provided for @month.
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get month;

  /// No description provided for @day.
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get day;

  /// No description provided for @hour.
  ///
  /// In ko, this message translates to:
  /// **'시간'**
  String get hour;

  /// No description provided for @min.
  ///
  /// In ko, this message translates to:
  /// **'분'**
  String get min;

  /// No description provided for @sec.
  ///
  /// In ko, this message translates to:
  /// **'초'**
  String get sec;

  /// No description provided for @date.
  ///
  /// In ko, this message translates to:
  /// **'날짜'**
  String get date;

  /// No description provided for @justNow.
  ///
  /// In ko, this message translates to:
  /// **'방금'**
  String get justNow;

  /// No description provided for @yesterday.
  ///
  /// In ko, this message translates to:
  /// **'어제'**
  String get yesterday;

  /// No description provided for @beforeOf.
  ///
  /// In ko, this message translates to:
  /// **'{time}전'**
  String beforeOf(Object time);

  /// No description provided for @am.
  ///
  /// In ko, this message translates to:
  /// **'오전'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In ko, this message translates to:
  /// **'오후'**
  String get pm;

  /// No description provided for @undefined.
  ///
  /// In ko, this message translates to:
  /// **'미정'**
  String get undefined;

  /// No description provided for @undefinedOf.
  ///
  /// In ko, this message translates to:
  /// **'{target} 미정'**
  String undefinedOf(Object target);

  /// No description provided for @inputHint1.
  ///
  /// In ko, this message translates to:
  /// **'{target}을 입력해주세요.'**
  String inputHint1(Object target);

  /// No description provided for @inputHint2.
  ///
  /// In ko, this message translates to:
  /// **'{target}를 입력해주세요.'**
  String inputHint2(Object target);

  /// No description provided for @copyText1.
  ///
  /// In ko, this message translates to:
  /// **'{target}이 복사되었어요'**
  String copyText1(Object target);

  /// No description provided for @copyText2.
  ///
  /// In ko, this message translates to:
  /// **'{target}가 복사되었어요'**
  String copyText2(Object target);

  /// No description provided for @ensureToDo.
  ///
  /// In ko, this message translates to:
  /// **'정말 {action}하시겠어요?'**
  String ensureToDo(Object action);

  /// No description provided for @successToDo.
  ///
  /// In ko, this message translates to:
  /// **'성공적으로 {action}했어요'**
  String successToDo(Object action);

  /// No description provided for @willDo.
  ///
  /// In ko, this message translates to:
  /// **'{action}할래요'**
  String willDo(Object action);

  /// No description provided for @ensureToResign.
  ///
  /// In ko, this message translates to:
  /// **'정말 계정을 삭제하시나요?'**
  String get ensureToResign;

  /// No description provided for @resignWarning.
  ///
  /// In ko, this message translates to:
  /// **'삭제 시 모든 데이터를\n다시는 복구할 수 없어요'**
  String get resignWarning;

  /// No description provided for @unknownException.
  ///
  /// In ko, this message translates to:
  /// **'알 수 없는 문제가 발생하였어요.'**
  String get unknownException;

  /// No description provided for @start.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get start;

  /// No description provided for @signIn.
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get signOut;

  /// No description provided for @signUp.
  ///
  /// In ko, this message translates to:
  /// **'가입하기'**
  String get signUp;

  /// No description provided for @resign.
  ///
  /// In ko, this message translates to:
  /// **'계정삭제'**
  String get resign;

  /// No description provided for @tokenExpired.
  ///
  /// In ko, this message translates to:
  /// **'로그인 정보가 만료되었어요'**
  String get tokenExpired;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In ko, this message translates to:
  /// **'이미 계정이 있나요?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @successToSignUp.
  ///
  /// In ko, this message translates to:
  /// **'가입이 완료되었어요.'**
  String get successToSignUp;

  /// No description provided for @phoneNumber.
  ///
  /// In ko, this message translates to:
  /// **'휴대폰 번호'**
  String get phoneNumber;

  /// No description provided for @inputPhoneNumber.
  ///
  /// In ko, this message translates to:
  /// **'휴대폰 번호를 입력해주세요'**
  String get inputPhoneNumber;

  /// No description provided for @existPhoneNumber.
  ///
  /// In ko, this message translates to:
  /// **'이미 가입된 휴대폰 번호에요.'**
  String get existPhoneNumber;

  /// No description provided for @password.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호'**
  String get password;

  /// No description provided for @inputPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 입력해주세요'**
  String get inputPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 확인'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 잊으셨나요?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 재설정'**
  String get resetPassword;

  /// No description provided for @mismatchPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 일치하지 않아요.'**
  String get mismatchPassword;

  /// No description provided for @successToResetPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 변경이 완료되었어요.'**
  String get successToResetPassword;

  /// No description provided for @receiveVerificationCode.
  ///
  /// In ko, this message translates to:
  /// **'인증문자 받기'**
  String get receiveVerificationCode;

  /// No description provided for @receiveVerificationCodeAgain.
  ///
  /// In ko, this message translates to:
  /// **'인증문자 다시 받기'**
  String get receiveVerificationCodeAgain;

  /// No description provided for @verificationCodeHint.
  ///
  /// In ko, this message translates to:
  /// **'인증번호 6자리'**
  String get verificationCodeHint;

  /// No description provided for @sentVerificationCode.
  ///
  /// In ko, this message translates to:
  /// **'인증번호가 문자로 전송되었어요.'**
  String get sentVerificationCode;

  /// No description provided for @wrongVerificationCode.
  ///
  /// In ko, this message translates to:
  /// **'인증번호를 다시 입력해주세요.'**
  String get wrongVerificationCode;

  /// No description provided for @setProfileAndNickname.
  ///
  /// In ko, this message translates to:
  /// **'프로필과 닉네임을 설정해주세요'**
  String get setProfileAndNickname;

  /// No description provided for @nameLengthHint.
  ///
  /// In ko, this message translates to:
  /// **'2글자 이상 입력해주세요'**
  String get nameLengthHint;

  /// No description provided for @nameHint.
  ///
  /// In ko, this message translates to:
  /// **'이름은 한글과 영어만 입력 가능해요'**
  String get nameHint;

  /// No description provided for @name.
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get name;

  /// No description provided for @nickname.
  ///
  /// In ko, this message translates to:
  /// **'닉네임'**
  String get nickname;

  /// No description provided for @statusMessage.
  ///
  /// In ko, this message translates to:
  /// **'상태 메세지'**
  String get statusMessage;

  /// No description provided for @statusMessageRecommend.
  ///
  /// In ko, this message translates to:
  /// **'상태 메세지를 입력해 보세요!'**
  String get statusMessageRecommend;

  /// No description provided for @editProfile.
  ///
  /// In ko, this message translates to:
  /// **'프로필 편집'**
  String get editProfile;

  /// No description provided for @setting.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get setting;

  /// No description provided for @profile.
  ///
  /// In ko, this message translates to:
  /// **'프로필'**
  String get profile;

  /// No description provided for @viewProfile.
  ///
  /// In ko, this message translates to:
  /// **'프로필 조회'**
  String get viewProfile;

  /// No description provided for @study.
  ///
  /// In ko, this message translates to:
  /// **'스터디'**
  String get study;

  /// No description provided for @myStudy.
  ///
  /// In ko, this message translates to:
  /// **'나의 스터디'**
  String get myStudy;

  /// No description provided for @addStudy.
  ///
  /// In ko, this message translates to:
  /// **'스터디 추가'**
  String get addStudy;

  /// No description provided for @createStudy.
  ///
  /// In ko, this message translates to:
  /// **'스터디 만들기'**
  String get createStudy;

  /// No description provided for @leaveStudy.
  ///
  /// In ko, this message translates to:
  /// **'스터디 탈퇴'**
  String get leaveStudy;

  /// No description provided for @editStudy.
  ///
  /// In ko, this message translates to:
  /// **'스터디 편집'**
  String get editStudy;

  /// No description provided for @joinedStudy.
  ///
  /// In ko, this message translates to:
  /// **'활동 스터디'**
  String get joinedStudy;

  /// No description provided for @studyName.
  ///
  /// In ko, this message translates to:
  /// **'스터디 이름'**
  String get studyName;

  /// No description provided for @studyDetail.
  ///
  /// In ko, this message translates to:
  /// **'상세 설명'**
  String get studyDetail;

  /// No description provided for @studyColor.
  ///
  /// In ko, this message translates to:
  /// **'스터디 색상'**
  String get studyColor;

  /// No description provided for @studyStart.
  ///
  /// In ko, this message translates to:
  /// **'스터디 시작!'**
  String get studyStart;

  /// No description provided for @studyColorHint.
  ///
  /// In ko, this message translates to:
  /// **'색상은 개인별로 설정이 가능해요'**
  String get studyColorHint;

  /// No description provided for @setStudyInfo.
  ///
  /// In ko, this message translates to:
  /// **'스터디 정보를 설정해 주세요'**
  String get setStudyInfo;

  /// No description provided for @startStudyWithFriend.
  ///
  /// In ko, this message translates to:
  /// **'친구들과 스터디를 시작해 보세요'**
  String get startStudyWithFriend;

  /// No description provided for @notWithUsNow.
  ///
  /// In ko, this message translates to:
  /// **'지금은 함께하지 않아요...'**
  String get notWithUsNow;

  /// No description provided for @participate.
  ///
  /// In ko, this message translates to:
  /// **'참여하기'**
  String get participate;

  /// No description provided for @invitingCode.
  ///
  /// In ko, this message translates to:
  /// **'초대코드'**
  String get invitingCode;

  /// No description provided for @shareInvitingCode.
  ///
  /// In ko, this message translates to:
  /// **'초대코드 공유'**
  String get shareInvitingCode;

  /// No description provided for @inputCode.
  ///
  /// In ko, this message translates to:
  /// **'코드를 입력해 주세요'**
  String get inputCode;

  /// No description provided for @invitingCodeHint.
  ///
  /// In ko, this message translates to:
  /// **'코드 6자리'**
  String get invitingCodeHint;

  /// No description provided for @shortInvitingCode.
  ///
  /// In ko, this message translates to:
  /// **'초대코드 6자리를 전부 입력해주세요'**
  String get shortInvitingCode;

  /// No description provided for @host.
  ///
  /// In ko, this message translates to:
  /// **'방장'**
  String get host;

  /// No description provided for @hostDelegation.
  ///
  /// In ko, this message translates to:
  /// **'방장 위임'**
  String get hostDelegation;

  /// No description provided for @hostDelegationHint.
  ///
  /// In ko, this message translates to:
  /// **'다른 팀원에게 방장을 위임할 수 있어요'**
  String get hostDelegationHint;

  /// No description provided for @ensureToDelegateHostTo.
  ///
  /// In ko, this message translates to:
  /// **'{nickname}에게\n방장을 위임할까요?'**
  String ensureToDelegateHostTo(Object nickname);

  /// No description provided for @member.
  ///
  /// In ko, this message translates to:
  /// **'멤버'**
  String get member;

  /// No description provided for @kick.
  ///
  /// In ko, this message translates to:
  /// **'내보내기'**
  String get kick;

  /// No description provided for @kicking.
  ///
  /// In ko, this message translates to:
  /// **'추방'**
  String get kicking;

  /// No description provided for @participateByCode.
  ///
  /// In ko, this message translates to:
  /// **'코드로 참여하기'**
  String get participateByCode;

  /// No description provided for @leave.
  ///
  /// In ko, this message translates to:
  /// **'탈퇴'**
  String get leave;

  /// No description provided for @stab.
  ///
  /// In ko, this message translates to:
  /// **'찌르기'**
  String get stab;

  /// No description provided for @stabUserAbout.
  ///
  /// In ko, this message translates to:
  /// **'\'{nickname}\'님을 {prefix}콕 찔렀어요'**
  String stabUserAbout(Object nickname, Object prefix);

  /// No description provided for @stabTaskAbout.
  ///
  /// In ko, this message translates to:
  /// **'과제를 {prefix}콕 찔렀어요'**
  String stabTaskAbout(Object prefix);

  /// No description provided for @num.
  ///
  /// In ko, this message translates to:
  /// **'번'**
  String get num;

  /// No description provided for @even.
  ///
  /// In ko, this message translates to:
  /// **'이나'**
  String get even;

  /// No description provided for @rules.
  ///
  /// In ko, this message translates to:
  /// **'규칙'**
  String get rules;

  /// No description provided for @writeRule.
  ///
  /// In ko, this message translates to:
  /// **'규칙 작성'**
  String get writeRule;

  /// No description provided for @ruleIsLimitedTo.
  ///
  /// In ko, this message translates to:
  /// **'규칙은 최대 {count}개 만들 수 있어요'**
  String ruleIsLimitedTo(Object count);

  /// No description provided for @task.
  ///
  /// In ko, this message translates to:
  /// **'과제'**
  String get task;

  /// No description provided for @scheduled.
  ///
  /// In ko, this message translates to:
  /// **'예정'**
  String get scheduled;

  /// No description provided for @taskAchievementRateIs.
  ///
  /// In ko, this message translates to:
  /// **'과제를 {rate}% 달성했어요'**
  String taskAchievementRateIs(Object rate);

  /// No description provided for @achievement.
  ///
  /// In ko, this message translates to:
  /// **'달성'**
  String get achievement;

  /// No description provided for @count.
  ///
  /// In ko, this message translates to:
  /// **'회'**
  String get count;

  /// No description provided for @round.
  ///
  /// In ko, this message translates to:
  /// **'회차'**
  String get round;

  /// No description provided for @roundList.
  ///
  /// In ko, this message translates to:
  /// **'회차 리스트'**
  String get roundList;

  /// No description provided for @addRound.
  ///
  /// In ko, this message translates to:
  /// **'회차 추가'**
  String get addRound;

  /// No description provided for @deleteRound.
  ///
  /// In ko, this message translates to:
  /// **'회차 삭제'**
  String get deleteRound;

  /// No description provided for @record.
  ///
  /// In ko, this message translates to:
  /// **'기록'**
  String get record;

  /// No description provided for @recordHint.
  ///
  /// In ko, this message translates to:
  /// **'스터디원 모두가 볼 수 있는 기록이에요'**
  String get recordHint;

  /// No description provided for @roundLimitWarning.
  ///
  /// In ko, this message translates to:
  /// **'회차는 최대 {count}개만 생성할 수 있어요'**
  String roundLimitWarning(Object count);

  /// No description provided for @noti.
  ///
  /// In ko, this message translates to:
  /// **'공지'**
  String get noti;

  /// No description provided for @notice.
  ///
  /// In ko, this message translates to:
  /// **'공지사항'**
  String get notice;

  /// No description provided for @title.
  ///
  /// In ko, this message translates to:
  /// **'제목'**
  String get title;

  /// No description provided for @content.
  ///
  /// In ko, this message translates to:
  /// **'내용'**
  String get content;

  /// No description provided for @confirmDeleteNotice.
  ///
  /// In ko, this message translates to:
  /// **'공지사항을 삭제하시겠어요?'**
  String get confirmDeleteNotice;

  /// No description provided for @tryToWriteNoti.
  ///
  /// In ko, this message translates to:
  /// **'공지를 작성해보세요'**
  String get tryToWriteNoti;

  /// No description provided for @comment.
  ///
  /// In ko, this message translates to:
  /// **'댓글'**
  String get comment;

  /// No description provided for @writeReply.
  ///
  /// In ko, this message translates to:
  /// **'답글쓰기'**
  String get writeReply;

  /// No description provided for @successToComment.
  ///
  /// In ko, this message translates to:
  /// **'댓글을 작성했어요'**
  String get successToComment;

  /// No description provided for @confirmDeleteComment.
  ///
  /// In ko, this message translates to:
  /// **'댓글을 삭제하시겠어요?'**
  String get confirmDeleteComment;

  /// No description provided for @attendanceRate.
  ///
  /// In ko, this message translates to:
  /// **'참석률'**
  String get attendanceRate;

  /// No description provided for @attendanceTag.
  ///
  /// In ko, this message translates to:
  /// **'출석태그'**
  String get attendanceTag;

  /// No description provided for @attend.
  ///
  /// In ko, this message translates to:
  /// **'참석'**
  String get attend;

  /// No description provided for @absent.
  ///
  /// In ko, this message translates to:
  /// **'결석'**
  String get absent;

  /// No description provided for @late.
  ///
  /// In ko, this message translates to:
  /// **'지각'**
  String get late;

  /// No description provided for @place.
  ///
  /// In ko, this message translates to:
  /// **'장소'**
  String get place;

  /// No description provided for @time.
  ///
  /// In ko, this message translates to:
  /// **'시간'**
  String get time;

  /// No description provided for @feedback.
  ///
  /// In ko, this message translates to:
  /// **'문의하기'**
  String get feedback;

  /// No description provided for @send.
  ///
  /// In ko, this message translates to:
  /// **'전송'**
  String get send;

  /// No description provided for @feedbackType.
  ///
  /// In ko, this message translates to:
  /// **'유형'**
  String get feedbackType;

  /// No description provided for @feedbackTitle.
  ///
  /// In ko, this message translates to:
  /// **'문의 제목'**
  String get feedbackTitle;

  /// No description provided for @feedbackContent.
  ///
  /// In ko, this message translates to:
  /// **'문의 내용'**
  String get feedbackContent;

  /// No description provided for @bug.
  ///
  /// In ko, this message translates to:
  /// **'버그 제보'**
  String get bug;

  /// No description provided for @feat.
  ///
  /// In ko, this message translates to:
  /// **'신규 기능'**
  String get feat;

  /// No description provided for @enhance.
  ///
  /// In ko, this message translates to:
  /// **'기능 개선'**
  String get enhance;

  /// No description provided for @etc.
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get etc;

  /// No description provided for @notificationCenter.
  ///
  /// In ko, this message translates to:
  /// **'알림 센터'**
  String get notificationCenter;

  /// No description provided for @notificationReadAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 읽기'**
  String get notificationReadAll;

  /// No description provided for @dummyForInsertion.
  ///
  /// In ko, this message translates to:
  /// **''**
  String get dummyForInsertion;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
