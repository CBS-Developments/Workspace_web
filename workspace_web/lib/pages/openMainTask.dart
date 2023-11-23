import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
    getSubTaskListByMainTaskId(widget.taskDetails.taskId);
    getCommentList(widget.taskDetails.taskId);
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
    print('Data laded in main task > userName: $userName > userRole: $userRole');
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
            Text(
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
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                '${widget.taskDetails.task_description}',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.black87),
                              ),

                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
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
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Task ID: ${widget.taskDetails.taskId}'),
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
                                        widget.taskDetails.taskStatusName,
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

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  if (widget.taskDetails.taskStatus == '0') {
                                    // Handle 'Mark In Progress' action
                                  } else if (widget.taskDetails.taskStatus ==
                                      '1') {
                                    // Handle 'Mark As Complete' action
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget.taskDetails.taskStatus == '0'
                                        ? 'Mark In Progress'
                                        : 'Mark As Complete',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          widget.taskDetails.taskStatus == '0'
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

                        // Display other task details similarly
                        // For example: Due date, assignee, status, etc.
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
                                        Text(
                                            'ID: ${subTaskList[index].taskId}'),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.person_pin_circle_rounded),
                                        Text('${subTaskList[index].assignTo} '),
                                        Icon(
                                          Icons.double_arrow_rounded,
                                          color: _getColorForTaskTypeName(
                                              subTaskList[index].taskTypeName),
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
                                        Text(
                                          'Due Date: ${subTaskList[index].dueDate}',
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (subTaskList[index].taskStatus ==
                                                '0') {
                                              // markInProgressMainTask(widget.task.taskTitle,widget.userName,widget.firstName, widget.task.taskId);
                                              // Handle 'Mark In Progress' action
                                            } else if (subTaskList[index]
                                                    .taskStatus ==
                                                '1') {
                                              // markAsCompletedMainTask(widget.task.taskTitle,widget.userName,widget.firstName, widget.task.taskId);
                                              // Handle 'Mark As Complete' action
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Text(
                                              subTaskList[index].taskStatus ==
                                                      '0'
                                                  ? 'Mark In Progress'
                                                  : 'Mark As Complete',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: subTaskList[index]
                                                            .taskStatus ==
                                                        '0'
                                                    ? Colors.blueAccent
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
                              addComment(context, userName: userName, taskID: widget.taskDetails.taskId, taskName: widget.taskDetails.taskTitle, firstName: firstName, lastName: lastName);
                              },
                              icon: Icon(Icons.add_comment_rounded,color: AppColor.appDarkBlue,size: 30,),


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
