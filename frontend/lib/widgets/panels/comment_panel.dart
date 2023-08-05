import 'package:flutter/material.dart';
import 'package:group_study_app/models/comment.dart';

class CommentPanel extends StatefulWidget {
  const CommentPanel({super.key});

  @override
  State<CommentPanel> createState() {
    return _CommentPanel();
  }
}

class _CommentPanel extends State<CommentPanel> {
  late List<Comment> comments;

  void getComments() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}