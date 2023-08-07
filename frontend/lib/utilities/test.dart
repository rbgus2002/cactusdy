import 'package:flutter/material.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/models/user.dart';

class Test {
  static final User testUser = User(userId: 1, nickname: "Arkady",statusMessage: "", picture: "");
  static final Study testStudy = Study(studyId: 1, studyName: '알고스터디', detail: '알고스터디', picture: "sad/asd");
  static final List<User> testUserList = List<User>.generate(30, (index) => User(userId: 0, nickname: "d", statusMessage: "", picture: ""));
  static final Round testRound = Round(roundId: 1, roundIdx: 1);


  static void onTabTest() {
    print('Tab!');
  }

  static Future<bool> waitSecond(int sec, bool returnValue) {
    return Future.delayed(Duration(seconds: sec), () => returnValue);
  }
}