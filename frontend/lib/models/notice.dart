import 'package:group_study_app/models/user.dart';

@Deprecated("tmp")
class NoticeTmp {
  final int noticeId;
  final String title;
  final String content;

  final User writer;
  final DateTime writingTime;

  const NoticeTmp({
    required this.noticeId,
    required this.title,
    required this.content,
    required this.writer,
    required this.writingTime,
  });

}