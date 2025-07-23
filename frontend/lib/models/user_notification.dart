import 'package:groupstudy/services/logger.dart';

class UserNotification {
  static Logger logger = Logger('UserNotification');

  final int id;
  final String title;
  final String message;
  final Map<String, dynamic> data;
  final DateTime createDate;
  bool isRead;

  UserNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.data,
    required this.createDate,
    required this.isRead,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      data: json['data'],
      isRead: json['isRead'],
      createDate: DateTime.parse(json["createDate"]),
    );
  }
}
