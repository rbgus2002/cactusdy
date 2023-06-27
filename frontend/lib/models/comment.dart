import 'package:group_study_app/models/user.dart';

class Comment {
  final User writer;
  final String content;
  final DateTime writingTime;

  const Comment({
    required this.writer,
    required this.content,
    required this.writingTime,
  });
}