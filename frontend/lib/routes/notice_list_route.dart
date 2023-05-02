import 'package:flutter/material.dart';

class NoticeListRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoticeListRoute();
  }
}

class _NoticeListRoute extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Notice List Screen',
        )
      )
    );
  }
}