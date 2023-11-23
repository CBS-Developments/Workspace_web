import 'package:flutter/material.dart';

import '../colors.dart';
import '../componants.dart';
import 'openMainTask.dart';

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
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Text(
          'Open Sub Task',
          style: TextStyle(
            color: AppColor.appBlue,
            fontSize: 20,
          ),
        ),
        // leading: IconButton(
        //   tooltip: 'Back to Main Task',
        //   onPressed: () {
        //     MaterialPageRoute(
        //         builder: (context) => OpenMainTaskPage(taskDetails: widget.mainTaskDetails,),
        //     );
        //   },
        //   icon: Icon(Icons.arrow_back_rounded),
        // ),
        leading: IconButton(
          tooltip: 'Back to Main Task',
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OpenMainTaskPage(taskDetails: widget.mainTaskDetails,),)
            );
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),

      body: Row(
        children: [
          Expanded(
            flex: 1,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    color: AppColor.appLightBlue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Main Task: ${widget.mainTaskDetails.taskTitle}',style: TextStyle(fontSize: 18),),
                      ],
                    ),
                  )
                ],
              ),),

          Divider(),

          Expanded(
            flex: 1,
            child: Column(),),
        ],
      ),
    );
  }
}
