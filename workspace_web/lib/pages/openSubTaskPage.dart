import 'package:flutter/material.dart';

import '../componants.dart';

class OpenSubTask extends StatefulWidget {
  final MainTask mainTaskDetails;
  final Task subTaskDetails;
  const OpenSubTask({super.key, required this.mainTaskDetails, required this.subTaskDetails});

  @override
  State<OpenSubTask> createState() => _OpenSubTaskState();
}

class _OpenSubTaskState extends State<OpenSubTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.mainTaskDetails.taskTitle} | ${widget.subTaskDetails.taskTitle}'),
      ),
    );
  }
}
