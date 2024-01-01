import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';
import '../componants.dart';
import 'package:http/http.dart' as http;

import 'openMainTask.dart';

class CompletedTaskPage extends StatefulWidget {
  const CompletedTaskPage({super.key});

  @override
  State<CompletedTaskPage> createState() => _CompletedTaskPageState();
}

class _CompletedTaskPageState extends State<CompletedTaskPage> {

  List<MainTask> mainTaskList = [];
  List<Task> subTaskList = [];
  String mainTaskName =
      'Please select a Main Task';
  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";

  @override
  void initState() {
    super.initState();
    getMainTaskList();
    loadData();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "";
      firstName = prefs.getString('first_name') ?? "";
      lastName = prefs.getString('last_name') ?? "";
      phone = prefs.getString('phone') ?? "";
      userRole = prefs.getString('user_role') ?? "";
    });
  }

  Future<void> getMainTaskList() async {
    mainTaskList.clear();
    var data = {};

    const url = "http://dev.workspace.cbs.lk/mainTaskListCom.php";
    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    if (res.statusCode == 200) {
      final responseJson = json.decode(res.body) as List<dynamic>;
      setState(() {
        for (Map<String, dynamic> details in responseJson) {
          mainTaskList.add(MainTask.fromJson(details));
        }
        mainTaskList.sort(
                (a, b) => b.taskCreatedTimestamp.compareTo(a.taskCreatedTimestamp));
      });
    } else {
      throw Exception('Failed to load jobs from API');
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Center(child: Text('Completed Main Tasks')),

      ),

      body: buildAllTasksList(),
    );
  }
  Widget buildAllTasksList() {
    List<MainTask> filteredTasks = [];

// Filter tasks based on taskStatus = 0
    filteredTasks = mainTaskList.where((task) => task.taskStatus == '2').toList();

    return filteredTasks.isNotEmpty
        ? Row(
      children: [
        Expanded(
          flex: 8,
          child: Container(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        String mainTaskId = filteredTasks[index].taskId;
                        getSubTaskListByMainTaskId(mainTaskId);
                        setState(() {
                          // Untap previously tapped containers
                          for (var task in filteredTasks) {
                            if (task != filteredTasks[index]) {
                              task.isContainerTapped = false;
                            }
                          }
                          // Toggle the tapped state for the current container
                          filteredTasks[index].isContainerTapped =
                          !filteredTasks[index].isContainerTapped;
                        });
                        setState(() {
                          mainTaskName =
                          'Sub Tasks of : ${filteredTasks[index].taskTitle}'; // Set the tapped main task's name
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  width: 5,
                                  color: _getColorForTaskTypeName(
                                      filteredTasks[index]
                                          .taskTypeName))),
                          color: filteredTasks[index].isContainerTapped
                              ? AppColor
                              .appLightBlue // Change this to the desired color when tapped
                              : Colors.grey.shade200,
                        ),
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SelectableText(
                              filteredTasks[index].taskTitle,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.appBlue),
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 5),
                                child: Row(
                                  children: [
                                    SelectableText(
                                        'ID: ${filteredTasks[index].taskId}'),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(Icons.person_pin_circle_rounded),
                                    Text(
                                        '${filteredTasks[index].assignTo} '),
                                    Icon(
                                      Icons.double_arrow_rounded,
                                    ),
                                    Text(
                                        ' ${filteredTasks[index].taskStatusName}...'),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 5),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text('Beneficiary: '),
                                        SelectableText(
                                          '${filteredTasks[index].company}',
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 5),
                                child: Row(
                                  children: [
                                    Text(
                                        'Create Date: ${filteredTasks[index].taskCreateDate}'),
                                    Icon(
                                      Icons.arrow_right,
                                      color: Colors.black87,
                                    ),
                                    SelectableText(
                                      'Due Date: ${filteredTasks[index].dueDate}',
                                      style: TextStyle(
                                          color: Colors.black87),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    // TextButton(
                                    //   onPressed: () {
                                    //     if (filteredTasks[index]
                                    //         .taskStatus ==
                                    //         '0') {
                                    //       markInProgressMainTask(
                                    //         context,
                                    //         taskName: filteredTasks[index]
                                    //             .taskTitle,
                                    //         userName: userName,
                                    //         firstName: firstName,
                                    //         taskID: filteredTasks[index]
                                    //             .taskId,
                                    //         logType: 'Main Task',
                                    //         logSummary:
                                    //         'Marked In-Progress',
                                    //         logDetails:
                                    //         'Main Task Due Date: ${filteredTasks[index].dueDate}',
                                    //       );
                                    //       // markInProgressMainTask(widget.task.taskTitle,widget.userName,widget.firstName, widget.task.taskId);
                                    //       // Handle 'Mark In Progress' action
                                    //     } else if (filteredTasks[index]
                                    //         .taskStatus ==
                                    //         '1') {
                                    //       markCompleteMainTask(context, taskName: filteredTasks[index]
                                    //           .taskTitle,
                                    //         userName: userName,
                                    //         firstName: firstName,
                                    //         taskID: filteredTasks[index]
                                    //             .taskId,
                                    //         logType: 'Main Task',
                                    //         logSummary:
                                    //         'Marked as Completed',
                                    //         logDetails:
                                    //         'Main Task Due Date: ${filteredTasks[index].dueDate}',);
                                    //       // markAsCompletedMainTask(widget.task.taskTitle,widget.userName,widget.firstName, widget.task.taskId);
                                    //       // Handle 'Mark As Complete' action
                                    //     }
                                    //   },
                                    //   child: Padding(
                                    //     padding:
                                    //     const EdgeInsets.all(0.0),
                                    //     child: Text(
                                    //       filteredTasks[index]
                                    //           .taskStatus ==
                                    //           '0'
                                    //           ? 'Mark In Progress'
                                    //           : 'Mark As Completed',
                                    //       style: TextStyle(
                                    //         fontSize: 14,
                                    //         color: filteredTasks[index]
                                    //             .taskStatus ==
                                    //             '0'
                                    //             ? Colors
                                    //             .deepPurple.shade600
                                    //             : Colors.green,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OpenMainTaskPage(
                                      taskDetails: filteredTasks[
                                      index]), // Pass the task details
                                ),
                              );
                              print('open task');
                            },
                            icon: Icon(Icons.open_in_new_rounded),
                            tooltip: 'Open Main Task',
                            focusColor: AppColor.appBlue,
                          ),

                          // Add onTap functionality if needed
                        ),
                      ),
                    ),
                    Divider(
                      color: AppColor.appBlue,
                    )
                  ],
                );
              },
            ),
          ),
        ),
        VerticalDivider(),
        Expanded(
          flex: 7,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      '$mainTaskName',
                      style: TextStyle(
                          color: AppColor.appDarkBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: subTaskList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(
                                50.0), // Adjust these values as needed
                            bottomRight: Radius.circular(
                                50.0), // Adjust these values as needed
                          ),
                          color: Colors.grey.shade200,
                        ),
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SelectableText(
                              subTaskList[index].taskTitle,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.appBlue),
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 5),
                                child: Row(
                                  children: [
                                    SelectableText(
                                        'ID: ${subTaskList[index].taskId}'),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.person_pin_circle_rounded),
                                    Text(
                                        '${subTaskList[index].assignTo} '),
                                    Icon(
                                      Icons.double_arrow_rounded,
                                      color: _getColorForTaskTypeName(
                                          subTaskList[index]
                                              .taskTypeName),
                                    ),
                                    Text(
                                        ' ${subTaskList[index].taskStatusName}...'),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_right,
                                      color: Colors.black87,
                                    ),
                                    SelectableText(
                                      'Due Date: ${subTaskList[index].dueDate}',
                                      style: TextStyle(
                                          color: Colors.black87),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    // TextButton(
                                    //   onPressed: () {
                                    //     if (subTaskList[index]
                                    //             .taskStatus ==
                                    //         '0') {
                                    //       // markInProgressMainTask(widget.task.taskTitle,widget.userName,widget.firstName, widget.task.taskId);
                                    //       // Handle 'Mark In Progress' action
                                    //     } else if (subTaskList[index]
                                    //             .taskStatus ==
                                    //         '1') {
                                    //       // markAsCompletedMainTask(widget.task.taskTitle,widget.userName,widget.firstName, widget.task.taskId);
                                    //       // Handle 'Mark As Complete' action
                                    //     }
                                    //   },
                                    //   child: Padding(
                                    //     padding:
                                    //         const EdgeInsets.all(0.0),
                                    //     child: Text(
                                    //       subTaskList[index].taskStatus ==
                                    //               '0'
                                    //           ? 'Mark In Progress'
                                    //           : 'Mark As Complete',
                                    //       style: TextStyle(
                                    //         fontSize: 14,
                                    //         color: subTaskList[index]
                                    //                     .taskStatus ==
                                    //                 '0'
                                    //             ? Colors.blueAccent
                                    //             : Colors.green,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // trailing: IconButton(
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => OpenSubTask(
                          //             mainTaskDetails:
                          //             filteredTasks[index],
                          //             subTaskDetails:
                          //             subTaskList[index],
                          //           )),
                          //     );
                          //     print('open task');
                          //   },
                          //   icon: Icon(Icons.open_in_new_rounded),
                          //   tooltip: 'Open Sub Task',
                          //   focusColor: AppColor.appBlue,
                          // ),

                          // Add onTap functionality if needed
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    )
        : Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "No matches found!!",
          style: TextStyle(color: Colors.redAccent, fontSize: 16),
        ),
      ),
    ); // Return an empty container if no search results or query
  }
}
