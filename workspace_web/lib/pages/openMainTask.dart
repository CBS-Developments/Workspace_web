import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace_web/pages/createSubTask.dart';
import 'package:workspace_web/pages/editMainTask.dart';
import '../colors.dart';
import '../componants.dart';
import 'openSubTaskPage.dart';

class OpenMainTaskPage extends StatefulWidget {
  final MainTask taskDetails;

  const OpenMainTaskPage({super.key, required this.taskDetails});
  @override
  State<OpenMainTaskPage> createState() => _OpenMainTaskPageState();
}

class _OpenMainTaskPageState extends State<OpenMainTaskPage> {
  TextEditingController commentTextController = TextEditingController();
  List<Task> subTaskList = [];
  List<comment> commentsList = [];
  List<TaskDetailsBox> taskDetailsList = [];

  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";
  String taskStatusName = "";
  String taskStatusNameController = "";
  String taskStatus = "";
  String buttonController = "";
  String nameNowUser='';

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
    getSubTaskListByMainTaskId(widget.taskDetails.taskId);
    getCommentList(widget.taskDetails.taskId);
    loadData();

    // Adding widget.taskDetails to taskDetailsList
    taskDetailsList.add(TaskDetailsBox(
        widget.taskDetails.task_description, widget.taskDetails.taskId));
    setState(() {
      taskStatus = widget.taskDetails.taskStatus; // Update taskStatus here
      buttonController =
          taskStatus; // Update buttonController based on taskStatus

      taskStatusName = widget.taskDetails.taskStatusName;
      taskStatusNameController = taskStatusName;
      nameNowUser= '${firstName} ${lastName}';

    });
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
    print(
        'Data laded in main task > userName: $userName > userRole: $userRole');
  }

  void showDeleteCommentConfirmation(
      BuildContext context,
      String commentID,
      String createBy,
      String nameNowUser,
      ) {
    print('Now user: $nameNowUser');
    print('Crate By: $createBy');
    if (createBy == nameNowUser) {
      print(createBy);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this Comment?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  deleteComment(commentID);
                  // deleteMainTask(taskId); // Call the deleteMainTask method
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      // Display a message or take other actions for users who are not admins
      print(createBy);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permission Denied'),
            content: const Text('Only your comments allowed to delete.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> deleteComment(
      String commentId,
      ) async {
    String logType = 'Comment';
    String logSummary = 'Deleted';
    String logDetails = '';
    // Prepare the data to be sent to the PHP script.

    var data = {
      "comment_id": commentId,
      "comment_delete_by": userName,
      "comment_delete_by_id": firstName,
      "comment_delete_by_date": getCurrentDate(),
      "comment_delete_by_timestamp": getCurrentDateTime(),
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/deleteComment.php";

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
          // snackBar(context, "Comment Deleted successful!", Colors.redAccent);
          addLog(context, taskId: widget.taskDetails.taskId, taskName: widget.taskDetails.taskTitle, createBy: firstName, createByID: userName, logType: logType, logSummary: logSummary, logDetails: logDetails);
          getCommentList(widget.taskDetails.taskId);
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

  void showDeleteConfirmationDialog(
    BuildContext context,
    String userRole,
    String taskId,
  ) {
    print('User Role in showDeleteConfirmationDialog: $userRole');
    if (userRole == '1') {
      print(userRole);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  deleteMainTask(taskId); // Call the deleteMainTask method
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      // Display a message or take other actions for users who are not admins
      print(userRole);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permission Denied'),
            content: const Text('Only admins are allowed to delete tasks.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> deleteMainTask(
    String taskID,
  ) async {
    String logType = 'Main Task';
    String logSummary = 'Deleted';
    String logDetails = '';
    // Prepare the data to be sent to the PHP script.
    var data = {
      "task_id": taskID,
      "task_status": '99',
      "task_status_name": 'Deleted',
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
          print('Deleted Successful');
          addLog(context,
              taskId: taskID,
              taskName: widget.taskDetails.taskTitle,
              createBy: firstName,
              createByID: userName,
              logType: logType,
              logSummary: logSummary,
              logDetails: logDetails);
          Navigator.pushNamed(context, '/Task');
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

  Future<void> getCommentList(String taskId) async {
    commentsList
        .clear(); // Assuming that `commentsList` is a List<Comment> in your class

    var data = {
      "task_id": taskId,
    };

    const url = "http://dev.workspace.cbs.lk/commentListById.php";
    http.Response response = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      setState(() {
        for (Map<String, dynamic> details
            in responseJson.cast<Map<String, dynamic>>()) {
          commentsList.add(comment
              .fromJson(details)); // Assuming Comment.fromJson method exists
        }
      });
    } else {
      throw Exception(
          'Failed to load data from the API. Status Code: ${response.statusCode}');
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
          addLog(context,
              taskId: taskID,
              taskName: taskName,
              createBy: firstName,
              createByID: userName,
              logType: logType,
              logSummary: logSummary,
              logDetails: logDetails);
          setState(() {
            // Update taskStatus here
            buttonController = '1';
            taskStatusNameController =
                'In Progress'; // Update buttonController based on taskStatus
          });

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
      "task_status": '2',
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
          addLog(context,
              taskId: taskID,
              taskName: taskName,
              createBy: firstName,
              createByID: userName,
              logType: logType,
              logSummary: logSummary,
              logDetails: logDetails);
          Navigator.pushNamed(context, '/Task');

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

  Future<bool> markInProgressSubTask(
    String taskName,
    String userName,
    String firstName,
    String taskID,
    String dueDate,
  ) async {
    String logType = 'Sub Task';
    String logSummary = 'Marked In-Progress';
    String logDetails = 'Sub Task Due Date: $dueDate';
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
    const url = "http://dev.workspace.cbs.lk/deleteSubTask.php";

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
          // snackBar(context, "Sub Task Marked as In Progress!", Colors.blueAccent);
          addLog(context,
              taskId: taskID,
              taskName: taskName,
              createBy: firstName,
              createByID: userName,
              logType: logType,
              logSummary: logSummary,
              logDetails: logDetails);
          getSubTaskListByMainTaskId(widget.taskDetails.taskId);
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

  Future<bool> markCompleteSubTask(
    String taskName,
    String userName,
    String firstName,
    String taskID,
    String dueDate,
  ) async {
    String logType = 'Sub Task';
    String logSummary = 'Marked as Completed';
    String logDetails = 'Sub Task Due Date: $dueDate';
    // Prepare the data to be sent to the PHP script.
    var data = {
      "task_id": taskID,
      "task_status": '2',
      "task_status_name": 'Completed',
      "action_taken_by_id": userName,
      "action_taken_by": firstName,
      "action_taken_date": getCurrentDateTime(),
      "action_taken_timestamp": getCurrentDate(),
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/deleteSubTask.php";

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
          // snackBar(context, "Sub Task Marked as In Progress!", Colors.blueAccent);
          addLog(context,
              taskId: taskID,
              taskName: taskName,
              createBy: firstName,
              createByID: userName,
              logType: logType,
              logSummary: logSummary,
              logDetails: logDetails);
          getSubTaskListByMainTaskId(widget.taskDetails.taskId);
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

  Future<bool> addComment(
    BuildContext context, {
    required userName,
    required taskID,
    required taskName,
    required firstName,
    required lastName,
    required logType,
    required logSummary,
    required logDetails,
  }) async {
    // Validate input fields
    if (commentTextController.text.trim().isEmpty) {
      // Show an error message if the combined fields are empty
      snackBar(context, "Please fill in all required fields", Colors.red);
      return false;
    }

    var url = "http://dev.workspace.cbs.lk/createComment.php";

    var data = {
      "comment_id": getCurrentDateTime(),
      "task_id": taskID,
      "comment": commentTextController.text,
      "comment_create_by_id": userName,
      "comment_create_by": "$firstName $lastName",
      "comment_create_date": getCurrentDate(),
      "comment_created_timestamp": getCurrentDateTime(),
      "comment_status": "1",
      "comment_edit_by": "",
      "comment_edit_by_id": '',
      "comment_edit_by_date": "",
      "comment_edit_by_timestamp": "",
      "comment_delete_by": "",
      "comment_delete_by_id": "",
      "comment_delete_by_date": "",
      "comment_delete_by_timestamp": "",
      "comment_attachment": '',
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
        if (!mounted) return true;
        commentTextController.clear();
        // snackBar(context, "Comment Added Successfully", Colors.green);
        getCommentList(taskID);
        addLog(context,
            taskId: taskID,
            taskName: taskName,
            createBy: firstName,
            createByID: userName,
            logType: logType,
            logSummary: logSummary,
            logDetails: logDetails);
      }
    } else {
      if (!mounted) return false;
      snackBar(context, "Error", Colors.redAccent);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve task details from arguments passed during navigation

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Main Task >',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
            SelectableText(
              '${widget.taskDetails.taskTitle}',
              style: TextStyle(
                color: AppColor.appDarkBlue,
                fontSize: 20,
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/Task',
            );
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1, color: AppColor.appDarkBlue)),
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              child: IconButton(
                  tooltip: 'Edit Main Task',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditMainTaskPage(
                                mainTaskDetails: widget.taskDetails,
                              ) // Pass the task details
                          ),
                    );
                  },
                  icon: Icon(
                    Icons.edit_note_rounded,
                    color: Colors.black87,
                  ))),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1, color: AppColor.appDarkBlue)),
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
            child: IconButton(
                tooltip: 'Delete Main Task',
                onPressed: () {
                  showDeleteConfirmationDialog(context, userRole, widget.taskDetails.taskId);
                },
                icon: Icon(
                  Icons.delete_sweep_outlined,
                  color: Colors.redAccent,
                )),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                ///task Id and Task description list
                Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: taskDetailsList.length,
                      itemBuilder: (context, index) {
                        if (index < taskDetailsList.length) {
                          return Container(
                            padding: EdgeInsets.only(bottom: 15),
                            color: Colors.white,
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SelectableText(
                                    'Task ID: ${taskDetailsList[index].taskId}'),
                              ),
                              subtitle: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6.0),
                                child: SelectableText(
                                    taskDetailsList[index].taskDescription),
                              ),
                              titleTextStyle: TextStyle(fontSize: 15),
                              subtitleTextStyle:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              // Your list item code here...
                            ),
                          );
                        } else {
                          return SizedBox(); // Or another fallback widget if needed
                        }
                      },
                    )),

                ///other details of task

                Expanded(
                  flex: 7,
                  child: Column(
                    children: [
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
                                          widget.taskDetails.taskCreateDate,
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
                                          widget.taskDetails.dueDate,
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
                                      widget.taskDetails.company,
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
                                      widget.taskDetails.assignTo,
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
                                      widget.taskDetails.category_name,
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
                                      taskStatusNameController,
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
                                      widget.taskDetails.taskCreateBy,
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

                      ///buttons row
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                if (buttonController == '0') {
                                  markInProgressMainTask(
                                    context,
                                    taskName: widget.taskDetails.taskTitle,
                                    userName: userName,
                                    firstName: firstName,
                                    taskID: widget.taskDetails.taskId,
                                    logType: 'Main Task',
                                    logSummary: 'Marked In-Progress',
                                    logDetails:
                                        'Main Task Due Date: ${widget.taskDetails.dueDate}',
                                  );
                                  // Handle 'Mark In Progress' action
                                } else if (buttonController == '1') {
                                  markCompleteMainTask(
                                    context,
                                    taskName: widget.taskDetails.taskTitle,
                                    userName: userName,
                                    firstName: firstName,
                                    taskID: widget.taskDetails.taskId,
                                    logType: 'Main Task',
                                    logSummary: 'Marked as Completed',
                                    logDetails:
                                        'Main Task Due Date: ${widget.taskDetails.dueDate}',
                                  );
                                  // Handle 'Mark As Complete' action
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  buttonController == '0'
                                      ? 'Mark In Progress'
                                      : 'Mark As Complete',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: buttonController == '0'
                                        ? Colors.deepPurple.shade600
                                        : Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateSubTaskPage(
                                            mainTaskDetails: widget.taskDetails,
                                          ) // Pass the task details
                                      ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: AppColor
                                        .appDarkBlue), // Change the border color
                                backgroundColor:
                                    Colors.white, // Change the background color
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

                      ///sub task list
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
                                            Icon(Icons
                                                .person_pin_circle_rounded),
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
                                            TextButton(
                                              onPressed: () {
                                                if (subTaskList[index]
                                                        .taskStatus ==
                                                    '0') {
                                                  markInProgressSubTask(
                                                      subTaskList[index]
                                                          .taskTitle,
                                                      userName,
                                                      firstName,
                                                      subTaskList[index].taskId,
                                                      subTaskList[index]
                                                          .dueDate);
                                                  // markInProgressMainTask(widget.task.taskTitle,widget.userName,widget.firstName, widget.task.taskId);
                                                  // Handle 'Mark In Progress' action
                                                } else if (subTaskList[index]
                                                        .taskStatus ==
                                                    '1') {
                                                  markCompleteSubTask(
                                                      subTaskList[index]
                                                          .taskTitle,
                                                      userName,
                                                      firstName,
                                                      subTaskList[index].taskId,
                                                      subTaskList[index]
                                                          .dueDate);
                                                  // markAsCompletedMainTask(widget.task.taskTitle,widget.userName,widget.firstName, widget.task.taskId);
                                                  // Handle 'Mark As Complete' action
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Text(
                                                  subTaskList[index]
                                                              .taskStatus ==
                                                          '0'
                                                      ? 'Mark In Progress'
                                                      : subTaskList[index]
                                                                  .taskStatus ==
                                                              '1'
                                                          ? 'Mark As Completed'
                                                          : 'Completed',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: subTaskList[index]
                                                                .taskStatus ==
                                                            '0'
                                                        ? Colors.blueAccent
                                                        : subTaskList[index]
                                                                    .taskStatus ==
                                                                '1'
                                                            ? Colors.green
                                                            : Colors
                                                                .grey, // Assuming '2' represents Completed status
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
                                            builder: (context) => OpenSubTask(
                                                  mainTaskDetails:
                                                      widget.taskDetails,
                                                  subTaskDetails:
                                                      subTaskList[index],
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
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Comments',
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 18),
                            ),
                            Icon(
                              Icons.arrow_right_rounded,
                              color: Colors.black87,
                              size: 27,
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(
                                50.0), // Adjust these values as needed
                            bottomRight: Radius.circular(
                                50.0), // Adjust these values as needed
                          ),
                          color: AppColor.appLightBlue,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Add your updates as comments!!',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),

                //comment list loading
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: commentsList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
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
                                  child: SelectableText(
                                    commentsList[index].commnt,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.appBlue),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                      '${commentsList[index].commentCreatedTimestamp}   By: ${commentsList[index].commentCreateBy}'),
                                ),

                                trailing: IconButton(
                                  onPressed: () {
                                    showDeleteCommentConfirmation(context, commentsList[index].commentId, commentsList[index].commentCreateBy, '${firstName} ${lastName}');
                                    print('Delete Comment');
                                  },
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.redAccent,
                                  ),
                                  tooltip: 'Delete Comment',
                                  focusColor: Colors.redAccent,
                                ),

                                // Add onTap functionality if needed
                              ),
                            ),
                            Divider(
                              color: AppColor.appLightBlue,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(15),
                  height: 100,
                  color: Colors.grey.shade200,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.none,
                          controller: commentTextController,
                          maxLines: 2, // Set the maximum lines to 2
                          decoration: InputDecoration(
                            hintText: 'Enter your comment...',
                          ),
                        ),
                        flex: 11,
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          tooltip: 'Add comment',
                          onPressed: () {
                            addComment(context,
                                userName: userName,
                                taskID: widget.taskDetails.taskId,
                                taskName: widget.taskDetails.taskTitle,
                                firstName: firstName,
                                lastName: lastName,
                                logType: 'to Main Task',
                                logSummary: 'Commented',
                                logDetails:
                                    " Comment: ${commentTextController.text}");
                          },
                          icon: Icon(
                            Icons.add_comment_rounded,
                            color: AppColor.appDarkBlue,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
