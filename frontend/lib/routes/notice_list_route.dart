import 'dart:convert';
import 'package:group_study_app/models/notice_summary.dart';

import 'package:flutter/material.dart';
import 'package:group_study_app/services/database_service.dart';
import 'package:group_study_app/widgets/panels/notice_widget.dart';

class NoticeListRoute extends StatefulWidget {
  final int studyId = 99;
  @override
  State<StatefulWidget> createState() {
    return _NoticeListRoute();
  }
}

class _NoticeListRoute extends State<NoticeListRoute> {
  late Future<List<NoticeSummary>> notices;
  @override
  void initState() {
    super.initState();
    notices = NoticeSummary.getNoticeSummaryList(widget.studyId);
  }

  Future<void> updateNotices() async {
    notices = NoticeSummary.getNoticeSummaryList(widget.studyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: notices,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                  onRefresh: updateNotices,
                  child: Column(
                    children: [
                      for (NoticeSummary notice in snapshot.data!)
                        NoticeWidget(noticeSummary: notice),
                    ]
                  )
              );
            } else
              return Text("공지가 없어용");
          }
        ,)
        )
    );
  }
}