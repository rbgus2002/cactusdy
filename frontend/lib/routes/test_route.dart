import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/widgets/panels/panel.dart';

class TestRoute extends StatefulWidget {
  const TestRoute({super.key});

  @override
  State<TestRoute> createState() => _TestRoute();
}

class _TestRoute extends State<TestRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ASD")),
      body: Column(
        children: [
          Flexible(child:
          ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) =>
                  Text('$index텍스트'),),
            ),
          Text("DDD"),
        ],
      ),
    );
  }
}