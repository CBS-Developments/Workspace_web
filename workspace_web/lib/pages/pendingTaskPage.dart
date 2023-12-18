import 'package:flutter/material.dart';

import '../colors.dart';

class PendingTaskPage extends StatefulWidget {
  const PendingTaskPage({super.key});

  @override
  State<PendingTaskPage> createState() => _PendingTaskPageState();
}

class _PendingTaskPageState extends State<PendingTaskPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Center(child: Text('Pending Main Task')),
      ),
    );
  }
}


