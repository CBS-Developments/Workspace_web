import 'dart:convert';
import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors.dart';
import '../componants.dart';
import 'openMainTask.dart';

class OpenSubTask extends StatefulWidget {
  final MainTask mainTaskDetails;
  final Task subTaskDetails;
  const OpenSubTask(
      {super.key, required this.mainTaskDetails, required this.subTaskDetails});

  @override
  State<OpenSubTask> createState() => _OpenSubTaskState();
}

class _OpenSubTaskState extends State<OpenSubTask> {
  List<Task> subTaskList = [];
  List<Task> filteredSubTaskList = [];
  TextEditingController commentTextController = TextEditingController();
  List<comment> commentsList = [];

  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";

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

  @override
  void initState() {
    super.initState();
    getSubTaskListByMainTaskId(widget.mainTaskDetails.taskId);
    getCommentList(widget.subTaskDetails.taskId);
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
    print('Data laded in sub task > userName: $userName > userRole: $userRole');
  }

  Future<bool> addComment(
    BuildContext context, {
    required userName,
    required taskID,
    required taskName,
    required firstName,
    required lastName,
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
      }
    } else {
      if (!mounted) return false;
      snackBar(context, "Error", Colors.redAccent);
    }
    return true;
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Main Task > Sub task',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
            Text(
              '${widget.mainTaskDetails.taskTitle} > ${widget.subTaskDetails.taskTitle}',
              style: TextStyle(
                color: AppColor.appDarkBlue,
                fontSize: 20,
              ),
            ),
          ],
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
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OpenMainTaskPage(
                    taskDetails: widget.mainTaskDetails,
                  ),
                ));
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
                              '${widget.subTaskDetails.taskDescription}',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                            Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            width: 1,
                                            color: AppColor.appDarkBlue)),
                                    margin: EdgeInsets.symmetric(horizontal: 5),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                            'Sub Task ID: ${widget.subTaskDetails.taskId}'),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
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
                                    style: TextStyle(color: Colors.black87),
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
            ),
          ),

          Divider(),

          ///comment list and add comment
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
                                  child: Text(
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
                                taskID: widget.subTaskDetails.taskId,
                                taskName: widget.subTaskDetails.taskTitle,
                                firstName: firstName,
                                lastName: lastName);
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
