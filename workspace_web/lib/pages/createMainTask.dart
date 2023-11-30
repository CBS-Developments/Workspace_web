import 'package:flutter/material.dart';

class CreateMainTask extends StatefulWidget {
  const CreateMainTask({super.key});

  @override
  State<CreateMainTask> createState() => _CreateMainTaskState();
}

class _CreateMainTaskState extends State<CreateMainTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Main Tack'),
      ),
    );
  }
}
