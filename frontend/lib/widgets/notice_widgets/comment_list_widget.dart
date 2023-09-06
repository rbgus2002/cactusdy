
import 'package:flutter/material.dart';
import 'package:group_study_app/models/comment.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/widgets/comment_widget.dart';

class CommentListWidget extends StatefulWidget {
  final int noticeId;

  CommentListWidget({
    super.key,
    required this.noticeId,
  });

  @override
  State<CommentListWidget> createState() => _CommentListWidget();
}

class _CommentListWidget extends State<CommentListWidget> {
  late Future<List<Comment>> futureComments;
  late List<Comment> comments;

  int _selectedIdx = Comment.commentWithNoParent;

  @override
  void initState() {
    super.initState();
    //futureComments = Comment.getCommentsFake(widget.noticeId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureComments,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          comments = snapshot.data!;
          return Column(
              children: [
                for (int i = 0; i < comments.length; ++i)
                  CommentWidget(comment: comments[i], index: i,
                      isSelected: (_selectedIdx == i), onTap: setReplyTo),
              ]
          );
        }

        return Design.loadingIndicator;
      }
    );
  }

  void setReplyTo(int index) {
    setState(() {
      // #Case : double check => uncheck
      if (_selectedIdx == index) {
        //_focusNode.unfocus();
        _selectedIdx = Comment.commentWithNoParent;
      }
      // #Case : check
      else {
        //_focusNode.requestFocus();
        _selectedIdx = index;
      }
    });
  }
}