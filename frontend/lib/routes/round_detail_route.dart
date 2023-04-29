import 'package:flutter/material.dart';

class RoundDetailRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RoundDetailRoute();
  }
}

class _RoundDetailRoute extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Text(
              'Round Detail Screen',
            )
        )
    );
  }
}