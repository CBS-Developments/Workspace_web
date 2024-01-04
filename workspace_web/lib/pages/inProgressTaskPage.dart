import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../colors.dart';
import '../componants.dart';
import 'openMainTask.dart';

class InProgressTaskPage extends StatefulWidget {
  const InProgressTaskPage({super.key});

  @override
  State<InProgressTaskPage> createState() => _InProgressTaskPageState();
}

class _InProgressTaskPageState extends State<InProgressTaskPage> {


  List<MainTask> mainTaskList = [];
  List<Task> subTaskList = [];
  String mainTaskName =
      'Please select a Main Task';
  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";

  String? searchAssignee;


  String? selectedAssignee;

  List<String> assigneeList = [
    '-- Select Assignee --',
    'All',
    'Deshika',
    'Iqlas',
    'Udari',
    'Shahiru',
    'Dinethri',
    'Damith',
    'Sulakshana',
    'Samadhi',
    'Sanjana',
  ];



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

  String getCurrentDateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return formattedDate;
  }

  String getCurrentDate() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }

  String getCurrentMonth() {
    final now = DateTime.now();
    final formattedDate = DateFormat('MM-dd').format(now);
    return formattedDate;
  }

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

      // Update selectedAssignee based on userRole
      if (userRole == "1") {
        selectedAssignee = '-- Select Assignee --';
      } else if (userRole == "0") {
        selectedAssignee = firstName;
      }

    });
  }

  Future<void> addLog(
      BuildContext context, {
        required taskId,
        required taskName,
        required createBy,
        required createByID,
        required logType,
        required logSummary,
        required logDetails,
      }) async {
    // If all validations pass, proceed with the registration
    var url = "http://dev.workspace.cbs.lk/addLogUpdate.php";

    var data = {
      "log_id": getCurrentDateTime(),
      "task_id": taskId,
      "task_name": taskName,
      "log_summary": logSummary,
      "log_type": logType,
      "log_details": logDetails,
      "log_create_by": createBy,
      "log_create_by_id": createByID,
      "log_create_by_date": getCurrentDate(),
      "log_create_by_month": getCurrentMonth(),
      "log_create_by_year": '',
      "log_created_by_timestamp": getCurrentDateTime(),
    };

    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (res.statusCode.toString() == "200") {
      if (jsonDecode(res.body) == "true") {
        if (!mounted) return;
        print('Log added!!');
      } else {
        if (!mounted) return;
        snackBar(context, "Error", Colors.red);
      }
    } else {
      if (!mounted) return;
      snackBar(context, "Error", Colors.redAccent);
    }
  }

  Future<bool> markInProgressMainTask(
      BuildContext context, {
        required taskName,
        required userName,
        required firstName,
        required taskID,
        required logType,
        required logSummary,
        required logDetails,
      }) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "task_id": taskID,
      "task_status": '1',
      "task_status_name": 'In Progress',
      "action_taken_by_id": userName,
      "action_taken_by": firstName,
      "action_taken_date": getCurrentDateTime(),
      "action_taken_timestamp": getCurrentDate(),
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/deleteMainTask.php";

    try {
      final res = await http.post(
        Uri.parse(url),
        body: data,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      if (res.statusCode == 200) {
        final responseBody = jsonDecode(res.body);

        // Debugging: Print the response data.
        print("Response from PHP script: $responseBody");

        if (responseBody == "true") {
          print('Successful');
          getMainTaskList();
          addLog(context,
              taskId: taskID,
              taskName: taskName,
              createBy: firstName,
              createByID: userName,
              logType: logType,
              logSummary: logSummary,
              logDetails: logDetails);
          snackBar(
              context, "Main Marked as In Progress successful!", Colors.green);

          return true; // PHP code was successful.
        } else {
          print('PHP code returned "false".');
          return false; // PHP code returned "false."
        }
      } else {
        print('HTTP request failed with status code: ${res.statusCode}');
        return false; // HTTP request failed.
      }
    } catch (e) {
      print('Error occurred: $e');
      return false; // An error occurred.
    }
  }

  Future<bool> markCompleteMainTask(
      BuildContext context, {
        required taskName,
        required userName,
        required firstName,
        required taskID,
        required logType,
        required logSummary,
        required logDetails,
      }) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "task_id": taskID,
      "task_status":'2',
      "task_status_name": 'Completed',
      "action_taken_by_id": userName,
      "action_taken_by": firstName,
      "action_taken_date": getCurrentDateTime(),
      "action_taken_timestamp": getCurrentDate(),
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/deleteMainTask.php";

    try {
      final res = await http.post(
        Uri.parse(url),
        body: data,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      if (res.statusCode == 200) {
        final responseBody = jsonDecode(res.body);

        // Debugging: Print the response data.
        print("Response from PHP script: $responseBody");

        if (responseBody == "true") {
          print('Successful');
          getMainTaskList();
          addLog(context,
              taskId: taskID,
              taskName: taskName,
              createBy: firstName,
              createByID: userName,
              logType: logType,
              logSummary: logSummary,
              logDetails: logDetails);
          snackBar(
              context, "Main task completed successfully!", Colors.green);

          return true; // PHP code was successful.
        } else {
          print('PHP code returned "false".');
          return false; // PHP code returned "false."
        }
      } else {
        print('HTTP request failed with status code: ${res.statusCode}');
        return false; // HTTP request failed.
      }
    } catch (e) {
      print('Error occurred: $e');
      return false; // An error occurred.
    }
  }


  Future<void> getMainTaskList() async {
    mainTaskList.clear();
    var data = {};

    const url = "http://dev.workspace.cbs.lk/mainTaskList.php";
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



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Center(child: Text('In-Progress Tasks')),
        actions: userRole == "1"
            ? [
          DropdownButton<String>(
            value: selectedAssignee,
            onChanged: (newValue) {
              setState(() {
                selectedAssignee = newValue;
              });
              // Filter the task list based on the selected assignee
              // Implement filtering logic here
            },
            items: assigneeList.map<DropdownMenuItem<String>>((assignee) {
              return DropdownMenuItem<String>(
                value: assignee,
                child: Text(assignee),
              );
            }).toList(),
          ),
          const SizedBox(width: 20), // Spacer if needed
        ]
            : null,  // Spacer if needed



      ),
      body: buildAllTasksList(),
    );
  }


  Widget buildAllTasksList() {
    List<MainTask> filteredTasks = [];

    // Filter tasks based on taskStatus = 0
    if (selectedAssignee == null || selectedAssignee == 'All' || selectedAssignee == '-- Select Assignee --') {
      filteredTasks = mainTaskList
          .where((task) => task.taskStatus == '1')
          .toList();
    } else {
      filteredTasks = mainTaskList
          .where((task) =>
      task.taskStatus == '1' &&
          task.assignTo.toLowerCase().contains(selectedAssignee!.toLowerCase()))
          .toList();
    }

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
                                    TextButton(
                                      onPressed: () {
                                        if (filteredTasks[index]
                                            .taskStatus ==
                                            '0') {
                                          markInProgressMainTask(
                                            context,
                                            taskName: filteredTasks[index]
                                                .taskTitle,
                                            userName: userName,
                                            firstName: firstName,
                                            taskID: filteredTasks[index]
                                                .taskId,
                                            logType: 'Main Task',
                                            logSummary:
                                            'Marked In-Progress',
                                            logDetails:
                                            'Main Task Due Date: ${filteredTasks[index].dueDate}',
                                          );
                                          // markInProgressMainTask(widget.task.taskTitle,widget.userName,widget.firstName, widget.task.taskId);
                                          // Handle 'Mark In Progress' action
                                        } else if (filteredTasks[index]
                                            .taskStatus ==
                                            '1') {
                                          markCompleteMainTask(context, taskName: filteredTasks[index]
                                              .taskTitle,
                                            userName: userName,
                                            firstName: firstName,
                                            taskID: filteredTasks[index]
                                                .taskId,
                                            logType: 'Main Task',
                                            logSummary:
                                            'Marked as Completed',
                                            logDetails:
                                            'Main Task Due Date: ${filteredTasks[index].dueDate}',);
                                          // markAsCompletedMainTask(widget.task.taskTitle,widget.userName,widget.firstName, widget.task.taskId);
                                          // Handle 'Mark As Complete' action
                                        }
                                      },
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(0.0),
                                        child: Text(
                                          filteredTasks[index]
                                              .taskStatus ==
                                              '0'
                                              ? 'Mark In Progress'
                                              : 'Mark As Completed',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: filteredTasks[index]
                                                .taskStatus ==
                                                '0'
                                                ? Colors
                                                .deepPurple.shade600
                                                : Colors.green,
                                          ),
                                        ),
                                      ),
                                    ),
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
