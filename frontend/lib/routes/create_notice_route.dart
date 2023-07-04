import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/routes/notice_detail_route.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/toast.dart';

class CreateNoticeRoute extends StatefulWidget {
  @override
  State<CreateNoticeRoute> createState() {
    return _CreateNoticeRoute();
  }
}

class _CreateNoticeRoute extends State<CreateNoticeRoute> {
  static const String _titleHintMessage = "제목을 입력해 주세요";
  static const String _contentHintMessage = "내용을 입력해 주세요";
  static const String _CreateFailMessage = "작성에 실패했습니다";

  String _title = "";
  String _contents = "";

  bool _checkValidation() {
    if (_title.isEmpty) {
      Toast.showToast(_titleHintMessage);
      return false;
    }

    if (_contents.isEmpty) {
      Toast.showToast(_contentHintMessage);
      return false;
    }

    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,),
        body: Container(
          padding: Design.edge15,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // [Title]
                TextField(
                  style: TextStyles.titleSmall,
                  maxLength: Notice.titleMaxLength,
                  decoration: const InputDecoration(
                    hintText: _titleHintMessage,
                  ),
                  onChanged: (text) {
                    setState(() { _title = text; });
                  },
                ),

                // [Contents]
                TextField(
                  maxLines: 16,
                  maxLength: Notice.contentsMaxLength,
                  textAlign: TextAlign.justify,
                  decoration: const InputDecoration(
                    hintText: _contentHintMessage,
                    border: null,
                  ),
                  onChanged: (text) {
                    setState(() { _contents = text; });
                  },
                ),

                // [Create Button]
                ElevatedButton(
                    onPressed: () {
                      if (_checkValidation()) {
                        Future<int> result = Notice.createNotice(
                        _title, _contents, Test.testUser.userId, Test.testStudy.studyId);

                        result.then((newNoticeId) {
                          if (Notice.isValidate(newNoticeId)) {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NoticeDetailRoute(newNoticeId)),
                            );
                          }

                          else {
                            Toast.showToast(_CreateFailMessage);
                          }
                        });
                      }
                    },
                    child: const Text("등록"))
              ]
            )
          )
        ),
    );
  }
}