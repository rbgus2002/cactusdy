import 'package:flutter/material.dart';

class RoundDetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RoundDetailScreen();
  }
}

class _RoundDetailScreen extends State<StatefulWidget> {
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