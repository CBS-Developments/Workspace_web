import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  List<Task> subTaskList = [];
  List<Task> filteredSubTaskList = [];

  Color _getColorForTaskTypeName(String taskTypeName) {
    Map<String, Color> colorMap = {
      'Top Urgent': Colors.red,
      'Medium': Colors.blue,
      'Regular': Colors.green,
      'Low': Colors.yellow,
    };
    return colorMap[taskTypeName] ??
        Colors.grey; // Provide a default color if null
  }

  @override
  void initState() {
    super.initState();
    getSubTaskListByMainTaskId(widget.mainTaskDetails.taskId);
    // getCommentList(widget.taskDetails.taskId);
  }

  Future<void> getSubTaskListByMainTaskId(String mainTaskId) async {
    subTaskList.clear();
    var data = {
      "main_task_id": mainTaskId,
    };

    const url = "http://dev.workspace.cbs.lk/subTaskListByMainTaskId.php";
    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (res.statusCode == 200) {
      final responseJson = json.decode(res.body);
      setState(() {
        for (Map<String, dynamic> details
        in responseJson.cast<Map<String, dynamic>>()) {
          subTaskList.add(Task.fromJson(details));
        }

        subTaskList.sort((a, b) => b.dueDate.compareTo(a.dueDate));
      });
    } else {
      throw Exception('Failed to load subtasks from API');
    }
  }


  @override
  Widget build(BuildContext context) {
    // Filter the subtask list excluding the opened subtask
    filteredSubTaskList = subTaskList
        .where((task) => task.taskId != widget.subTaskDetails.taskId)
        .toList();

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

  /// main task details
                  Container(
                    width: double.infinity,
                    height: 50,
                    color: Colors.grey.shade300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0,),
                          child: Text('Main Task: ${widget.mainTaskDetails.taskTitle}',style: TextStyle(fontSize: 18),),
                        ),
                        SizedBox(height: 2,),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0,),
                          child: Text('Main Task ID: ${widget.mainTaskDetails.taskId}',style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ),
                      ],
                    ),
                  ),

  /// sub task detail start
                  Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${widget.subTaskDetails.taskTitle}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          border: Border.all(
                                              width: 1,
                                              color: AppColor.appDarkBlue)),
                                      margin:
                                      EdgeInsets.symmetric(horizontal: 5),
                                      child: IconButton(
                                          tooltip: 'Edit Main Task',
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.edit_note_rounded,
                                            color: Colors.black87,
                                          ))),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            width: 1,
                                            color: AppColor.appDarkBlue)),
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    child: IconButton(
                                        tooltip: 'Delete Main Task',
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.delete_sweep_outlined,
                                          color: Colors.redAccent,
                                        )),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            '${widget.subTaskDetails.taskDescription}',
                            style:
                            TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Task ID: ${widget.subTaskDetails.taskId}'),
                        ),

                        Container(
                          // width: 480,
                          margin: EdgeInsets.all(5),
                          height: 160,
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 120,
                                height: 160,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_rounded,
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4,
                                              bottom: 8,
                                              top: 8,
                                              right: 4),
                                          child: Text(
                                            'Start',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppColor.drawerLight),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: AppColor.drawerLight,
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4,
                                              bottom: 8,
                                              top: 8,
                                              right: 4),
                                          child: Text(
                                            'Due',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppColor.drawerLight),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        'Company',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        'Assign To',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        'Category',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        'Status',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        'Created By',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const VerticalDivider(
                                thickness: 2,
                              ),
                              SizedBox(
                                height: 160,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_rounded,
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4,
                                              bottom: 8,
                                              top: 8,
                                              right: 4),
                                          child: Text(
                                            widget.subTaskDetails.taskCreateDate,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.black,
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4,
                                              bottom: 8,
                                              top: 8,
                                              right: 4),
                                          child: Text(
                                            widget.subTaskDetails.dueDate,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        widget.subTaskDetails.company,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        widget.subTaskDetails.assignTo,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        widget.subTaskDetails.categoryName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        widget.subTaskDetails.taskStatusName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        widget.subTaskDetails.taskCreateBy,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  if (widget.subTaskDetails.taskStatus == '0') {
                                    // Handle 'Mark In Progress' action
                                  } else if (widget.subTaskDetails.taskStatus ==
                                      '1') {
                                    // Handle 'Mark As Complete' action
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget.subTaskDetails.taskStatus == '0'
                                        ? 'Mark In Progress'
                                        : 'Mark As Complete',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                      widget.subTaskDetails.taskStatus == '0'
                                          ? Colors.deepPurple.shade600
                                          : Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: AppColor
                                          .appDarkBlue), // Change the border color
                                  backgroundColor: Colors
                                      .white, // Change the background color
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Add Sub Task',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.appDarkBlue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),



                        // Display other Other sub task details similarly

                      ],
                    ),
                  ),

  /// other sub tasks
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: filteredSubTaskList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                    0.0), // Adjust these values as needed
                                bottomRight: Radius.circular(
                                    0.0), // Adjust these values as needed
                              ),
                              color: Colors.grey.shade200,
                            ),
                            margin: EdgeInsets.all(10),
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  filteredSubTaskList[index].taskTitle,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.appBlue),
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  children: [
                                    Text(
                                        'ID: ${filteredSubTaskList[index].taskId}'),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.arrow_right,
                                      color: Colors.black87,
                                    ),
                                    Text(
                                      'Due Date: ${filteredSubTaskList[index].dueDate}',
                                      style:
                                      TextStyle(color: Colors.black87),
                                    ),

                                  ],
                                ),
                              ),

                              trailing: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OpenSubTask(
                                          mainTaskDetails:
                                          widget.mainTaskDetails,
                                          subTaskDetails:
                                          filteredSubTaskList[index],
                                        )),
                                  );
                                  print('open sub task');
                                },
                                icon: Icon(Icons.open_in_new_rounded),
                                tooltip: 'Open Sub Task',
                                focusColor: AppColor.appBlue,
                              ),

                              // Add onTap functionality if needed
                            ),
                          );
                        },
                      ),
                    ),
                  ),
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
