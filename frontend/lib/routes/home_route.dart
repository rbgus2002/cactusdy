import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeRoute();
  }
}

class _HomeRoute extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Home Screen',
        )
      )
    );
  }
}