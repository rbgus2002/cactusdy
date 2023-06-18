import 'package:flutter/material.dart';
import 'package:group_study_app/widgets/panels/notice_widget.dart';

class NoticeListRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoticeListRoute();
  }
}

class _NoticeListRoute extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Notice List Screen',
            ),
            NoticeWidget(
                title: "[공지] 내일 늦게 오는 사람 커피 사기;;",
                content: "아니 요즘 정시에 오는 사람이 없음 ㅋㅋㅋㅋㅋ 고로 다음 스터디인 내일부터 늦게 오는 사람이 커피사는 걸로 합시다!! 반박시 이완용",
                fixed: true,
            ),
            NoticeWidget(
                title: "[공지] 이번주 금요일은 종강 기념으로 쉽니다~",
              content: "아 ㅋㅋ 드디어 종강~~ 아닛 아직도 종강 못한 사람이 있다?? 하하 그런사람이 있을리가 ~~ 다들 시험 보시느라 고생 많으셨습니다. 고생한 기념으로 이번주 스터디까지만 쉬고 바로 다음주부터 이어서 하도록 합시다!! 반박시 이완용",),
            NoticeWidget(title: "[공지] 저 결혼합니다..~", content: "SDF"),
            NoticeWidget(title: "asd", content: "SDF"),
          ],
        )
      )
    );
  }
}