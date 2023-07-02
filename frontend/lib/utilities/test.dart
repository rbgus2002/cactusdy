import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/models/user.dart';

class Test {
  static final User testUser = User(userId: 1, nickName: "Arkady", image: "");
  static final Study testStudy = Study(studyId: 1);
  static void onTabTest() {
    print('Tab!');
  }

  static Future<bool> waitSecond(int sec, bool returnValue) {
    return Future.delayed(Duration(seconds: sec), () => returnValue);
  }
}