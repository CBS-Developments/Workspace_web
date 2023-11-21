import 'package:flutter/material.dart';

import '../colors.dart';
import '../componants.dart';

class OpenMainTaskPage extends StatefulWidget {
  @override
  State<OpenMainTaskPage> createState() => _OpenMainTaskPageState();
}

class _OpenMainTaskPageState extends State<OpenMainTaskPage> {
  @override
  Widget build(BuildContext context) {
    // Retrieve task details from arguments passed during navigation
    final Map<String, dynamic> args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    // Access task details
    final MainTask taskDetails = args['taskDetails'];

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Text(
          'Open Main Task',
          style: TextStyle(
            color: AppColor.appBlue,
            fontSize: 20,
          ),
        ),
        leading: IconButton(onPressed: () {
          Navigator.pushNamed(
            context,
            '/Task',
          );
        }, icon: Icon(Icons.arrow_back_rounded),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Title: ${taskDetails.taskTitle}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Task ID: ${taskDetails.taskId}'),
            // Display other task details similarly
            // For example: Due date, assignee, status, etc.
          ],
        ),
      ),
    );
  }
}
