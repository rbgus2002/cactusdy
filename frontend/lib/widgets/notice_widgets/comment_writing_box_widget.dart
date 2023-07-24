import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/comment_controller.dart';
import 'package:group_study_app/utilities/toast.dart';

@Deprecated("테스트 작성")
class CommentWritingBox extends StatefulWidget {
  final CommentController controller;

  const CommentWritingBox({
    super.key,
    required this.controller,
  });

  @override
  State<CommentWritingBox> createState() => _CommentWritingBox();
}

@Deprecated("테스트 작성")
class _CommentWritingBox extends State<CommentWritingBox> {
  static const String _commentHintMessage = "댓글을 입력해 주세요";
  static const String _writingFailMessage = "작성에 실패했습니다";

  final TextEditingController _commentEditor = TextEditingController();
  late final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Design.edge10,
      child: TextField(
        minLines: 1,
        maxLines: 5,
        style: TextStyles.bodyMedium,
        textAlign: TextAlign.justify,
        controller: _commentEditor,
        focusNode: _focusNode,

        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: _commentHintMessage,

          suffixIcon: IconButton(
            icon: const Icon(Icons.send, size: 16),
            splashRadius: 16,
            onPressed: () {
              //if (_checkValidate()) {
                //_writeComment();
              //}
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentEditor.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /*
  void _writeComment() {
    int? parentCommentId = (_selectedIdx != Comment.commentWithNoParent)? comments[_selectedIdx].commentId : null;
    Future<int> result = Comment.writeComment(
        widget.user.userId, widget.noticeId, _commentEditor.text, parentCommentId);

    result.then((newCommentId) {
      if (newCommentId != Comment.commentCreationError) {
        setState(() {
          // writing box reset
          _commentEditor.text = "";
          _focusNode.unfocus();

          // commentList reloads
          futureComments = Comment.getComments(widget.noticeId);
          futureNotice.then((value) => ++value.commentCount); //< FIXME : this is not validated value, see also removeComment
        });
      }
      else {
        Toast.showToast(msg: _writingFailMessage);
      }
    });
  }

  bool _checkValidate() {
    if (_commentEditor.text.isEmpty) {
      Toast.showToast(msg: _commentHintMessage);
      return false;
    }
    return true;
  }

   */
}