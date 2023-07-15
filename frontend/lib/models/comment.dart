import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class Comment {
  final User writer;
  final String content;
  final DateTime writingTime;

  const Comment({
    required this.writer,
    required this.content,
    required this.writingTime,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      writer: json['writer'],
      content: json['content'],
      writingTime: json['writingTime'],
    );
  }

  void getComment(int noticeId) async {
    /*
    try {
      final response = await http.get(
        Uri.parse('${DatabaseService.serverUrl}comments?noticeId=$noticeId'),
      );

      if (response.statusCode != DatabaseService.SUCCESS_CODE) {
        throw Exception("Failed to load comment");
      } else {
        var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['comment'];

        return (responseJson as List).map((p) => )
      }
    }
    catch (e) {
      print(e);
    }

     */
  }
}