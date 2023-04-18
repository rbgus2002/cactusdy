import 'package:flutter/material.dart';

class NoticeDetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoticeDetailScreen();
  }
}

class _NoticeDetailScreen extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Text(
              'Notice Detail Screen',
            )
        )
    );
  }
}