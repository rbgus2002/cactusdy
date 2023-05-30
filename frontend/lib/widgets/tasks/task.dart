import 'package:flutter/material.dart';

abstract class Task extends StatefulWidget {
  final int taskid;
  bool isDone();

  Task({
    Key? key,
    required this.taskid,
  }) : super(key: key);
}