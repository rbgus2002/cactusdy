
import 'package:group_study_app/models/comment.dart';

class CommentController {
  final int noticeId;
  int _replyTo = Comment.commentWithNoParent;

  CommentController({
    required this.noticeId,
  });

  void setReplyTo(int index) {
    /*
    // #Case : double check => uncheck
    if (_replyTo == index) {
      _focusNode.unfocus();
      _selectedIdx = Comment.commentWithNoParent;
    }
    // #Case : check
    else {
      _focusNode.requestFocus();
      _selectedIdx = index;
    }

     */
  }
}