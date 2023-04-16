import 'package:flutter/material.dart';

class NoticeListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoticeListScreen();
  }
}

class _NoticeListScreen extends State<StatefulWidget> {
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