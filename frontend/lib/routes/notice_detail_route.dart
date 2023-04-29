import 'package:flutter/material.dart';

class NoticeDetailRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoticeDetailRoute();
  }
}

class _NoticeDetailRoute extends State<StatefulWidget> {
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