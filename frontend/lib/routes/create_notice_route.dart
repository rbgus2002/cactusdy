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
  String _title = "";
  String _contents = "";

  bool _checkValidation() {
    //< FIXME : Button Deactivation | Toast Message?
    if (_title.isEmpty || _contents.isEmpty) {
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
                TextField( // [Title]
                  style: TextStyles.titleSmall,
                  maxLength: Notice.titleMaxLength,
                  decoration: const InputDecoration(
                    hintText: "제목을 입력해 주세요.",
                  ),
                  onChanged: (text) {
                    setState(() { _title = text; });
                  },
                ),

                TextField( // [Contents]
                  maxLines: 16,
                  maxLength: Notice.contentsMaxLength,
                  textAlign: TextAlign.justify,
                  decoration: const InputDecoration(
                    hintText: "내용을 입력해 주세요.",
                    border: null,
                  ),
                  onChanged: (text) {
                    setState(() { _contents = text; });
                  },
                ),

                ElevatedButton( // [Create Button]
                    onPressed: () {
                      if (_checkValidation()) {
                        Future<bool> result = Notice.createNotice(
                        _title, _contents, Test.testUser.userId, Test.testStudy.studyId);
                        result.then((value) {
                          if (value) {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NoticeDetailRoute()),
                            );
                          }
                          else {
                            //< FIXME : 대충 토스터로 게시물 작성에 실패했다고 띄우기
                            //< FIXME : 혹은 그냥 버튼을 비활성화 시킬까?
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