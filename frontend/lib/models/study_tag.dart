
import 'package:flutter/material.dart';

class StudyTag {
  final String studyName;
  final String studyProfileImage;
  final Color studyColor;

  StudyTag({
    required this.studyName,
    required this.studyProfileImage,
    required this.studyColor,
  });

  factory StudyTag.fromJson(Map<String, dynamic> json) {
    return StudyTag(
        studyName: json['name'],
        studyProfileImage: json['studyProfileImage']??"",
        studyColor: Color(int.parse((json['color'] as String).substring(2), radix: 16))
    );
  }
}