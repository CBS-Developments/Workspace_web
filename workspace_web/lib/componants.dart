import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace_web/pages/profilePage.dart';

Future<void> snackBar(BuildContext context, String message, Color color) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: TextStyle(color: color, fontSize: 17.0),
    ),
  ));
}


// class MyDrawer extends StatefulWidget {
//   const MyDrawer({Key? key}) : super(key: key);
//
//   @override
//   State<MyDrawer> createState() => _MyDrawerState();
// }
//
// class _MyDrawerState extends State<MyDrawer> {
//   late Map<String, bool> _itemFocus;
//
//   @override
//   void initState() {
//     super.initState();
//     _itemFocus = {
//       'Dashboard': false,
//       'Task': false,
//       'Mail': false,
//       'Calendar': false,
//       'Special Notice': false,
//       'Chat': false,
//       'Users': false,
//       'Meet': false,
//       'Apps': false,
//     };
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: [
//           for (var item in _itemFocus.keys)
//             _buildDrawerItem(
//               item,
//               _getIcon(item),
//                   () {
//                 _updateFocus(item);
//                 Navigator.pushReplacementNamed(context, '/$item');
//               },
//               _itemFocus[item]!,
//             ),
//         ],
//       ),
//     );
//   }
//
//   void _updateFocus(String selectedItem) {
//     setState(() {
//       _itemFocus.updateAll((key, value) => key == selectedItem);
//     });
//   }
//
//   IconData _getIcon(String itemName) {
//     switch (itemName) {
//       case 'Dashboard':
//         return Icons.dashboard;
//       case 'Task':
//         return Icons.task;
//       case 'Mail':
//         return Icons.mail_rounded;
//       case 'Calendar':
//         return Icons.calendar_month_rounded;
//       case 'Special Notice':
//         return Icons.notifications;
//       case 'Chat':
//         return Icons.chat;
//       case 'Users':
//         return Icons.person;
//       case 'Meet':
//         return Icons.video_chat_rounded;
//       case 'Apps':
//         return Icons.app_shortcut_rounded;
//       default:
//         return Icons.error;
//     }
//   }
//
//   Widget _buildDrawerItem(
//       String title,
//       IconData icon,
//       Function() onTapFunction,
//       bool isFocused,
//       ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
//       child: Material(
//         color: Colors.teal.shade100,
//         borderRadius: BorderRadius.circular(15.0),
//         child: GestureDetector(
//           onTap: onTapFunction,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15.0),
//               color: isFocused ? Colors.teal.shade300 : Colors.transparent,
//             ),
//             child: ListTile(
//               leading: Icon(icon,color: isFocused ? Colors.black : Colors.black87,),
//               title: Text(
//                 title,
//                 style: TextStyle(
//                   color: isFocused ? Colors.black : Colors.black,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late Map<String, bool> _itemFocus;

  @override
  void initState() {
    super.initState();
    _itemFocus = {
      'Dashboard': false,
      'Task': false,
      'Mail': false,
      'Calendar': false,
      'Special Notice': false,
      'Chat': false,
      'Users': false,
      //'Meet': false,
      'Log': false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add your company logo here
                Center(
                  child: Image.asset(
                    'assets/logo.png', // Replace with the path to your logo
                    width: 100,
                    height: 100,
                  ),
                ),
                const Center(
                  child: Text(
                    'CBS Workspace',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),
          for (var item in _itemFocus.keys)
            _buildDrawerItem(
              item,
              _getIcon(item),
                  () {
                _updateFocus(item);
                Navigator.pushReplacementNamed(context, '/$item');
              },
              _itemFocus[item]!,
            ),
        ],
      ),
    );
  }


  void _updateFocus(String selectedItem) {
    setState(() {
      _itemFocus.updateAll((key, value) => key == selectedItem);
    });
  }

  IconData _getIcon(String itemName) {
    switch (itemName) {
      case 'Dashboard':
        return Icons.dashboard;
      case 'Task':
        return Icons.task;
      case 'Mail':
        return Icons.mail_rounded;
      case 'Calendar':
        return Icons.calendar_month_rounded;
      case 'Special Notice':
        return Icons.notifications;
      case 'Chat':
        return Icons.chat;
      case 'Users':
        return Icons.person;
      // case 'Meet':
      //   return Icons.video_chat_rounded;
      case 'Log':
        return Icons.app_shortcut_rounded;
      default:
        return Icons.error;
    }
  }

  Widget _buildDrawerItem(
      String title,
      IconData icon,
      Function() onTapFunction,
      bool isFocused,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
      child: Material(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
        child: GestureDetector(
          onTap: onTapFunction,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: isFocused ? Colors.grey[400] : Colors.transparent,
            ),
            child: ListTile(
              leading: Icon(icon,color: isFocused ? Colors.black : Colors.black87,),
              title: Text(
                title,
                style: TextStyle(
                  color: isFocused ? Colors.black : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyAppBar extends StatefulWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      backgroundColor: Colors.teal.shade200,
      foregroundColor: Colors.black,
      title: const Text(
        'CBS Workspace',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      actions: [
        Column(
          children: [
            const Text(
              '',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Text(
              "$firstName $lastName",
              style: const TextStyle(color: Colors.black, fontSize: 18.0),
            ),
          ],
        ),
        const SizedBox(width: 10,),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const ProfilePage();
              },
            );
          },
          icon: const Icon(
            Icons.account_circle_sharp,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}



class MainTask {
  String taskId;
  String taskTitle;
  String taskType;
  String taskTypeName;
  String dueDate;
  String task_description;
  String taskCreateById;
  String taskCreateBy;
  String taskCreateDate;
  String taskCreateMonth;
  String taskCreatedTimestamp;
  String taskStatus;
  String taskStatusName;
  String taskReopenBy;
  String taskReopenById;
  String taskReopenDate;
  String taskReopenTimestamp;
  String taskFinishedBy;
  String taskFinishedById;
  String taskFinishedByDate;
  String taskFinishedByTimestamp;
  String taskEditBy;
  String taskEditById;
  String taskEditByDate;
  String taskEditByTimestamp;
  String taskDeleteBy;
  String taskDeleteById;
  String taskDeleteByDate;
  String taskDeleteByTimestamp;
  String sourceFrom;
  String assignTo;
  String company;
  String documentNumber;
  String category_name;
  String category;
  bool isContainerTapped;

  MainTask({
    required this.taskId,
    required this.taskTitle,
    required this.taskType,
    required this.taskTypeName,
    required this.dueDate,
    required this.task_description,
    required this.taskCreateById,
    required this.taskCreateBy,
    required this.taskCreateDate,
    required this.taskCreateMonth,
    required this.taskCreatedTimestamp,
    required this.taskStatus,
    required this.taskStatusName,
    required this.taskReopenBy,
    required this.taskReopenById,
    required this.taskReopenDate,
    required this.taskReopenTimestamp,
    required this.taskFinishedBy,
    required this.taskFinishedById,
    required this.taskFinishedByDate,
    required this.taskFinishedByTimestamp,
    required this.taskEditBy,
    required this.taskEditById,
    required this.taskEditByDate,
    required this.taskEditByTimestamp,
    required this.taskDeleteBy,
    required this.taskDeleteById,
    required this.taskDeleteByDate,
    required this.taskDeleteByTimestamp,
    required this.sourceFrom,
    required this.assignTo,
    required this.company,
    required this.documentNumber,
    required this.category_name,
    required this.category,
    this.isContainerTapped = false,
  });

  factory MainTask.fromJson(Map<String, dynamic> json) {
    return MainTask(
      taskId: json['task_id'],
      taskTitle: json['task_title'],
      taskType: json['task_type'],
      taskTypeName: json['task_type_name'],
      dueDate: json['due_date'],
      task_description: json['task_description'],
      taskCreateById: json['task_create_by_id'],
      taskCreateBy: json['task_create_by'],
      taskCreateDate: json['task_create_date'],
      taskCreateMonth: json['task_create_month'],
      taskCreatedTimestamp: json['task_created_timestamp'],
      taskStatus: json['task_status'],
      taskStatusName: json['task_status_name'],
      taskReopenBy: json['task_reopen_by'],
      taskReopenById: json['task_reopen_by_id'],
      taskReopenDate: json['task_reopen_date'],
      taskReopenTimestamp: json['task_reopen_timestamp'],
      taskFinishedBy: json['task_finished_by'],
      taskFinishedById: json['task_finished_by_id'],
      taskFinishedByDate: json['task_finished_by_date'],
      taskFinishedByTimestamp: json['task_finished_by_timestamp'],
      taskEditBy: json['task_edit_by'],
      taskEditById: json['task_edit_by_id'],
      taskEditByDate: json['task_edit_by_date'],
      taskEditByTimestamp: json['task_edit_by_timestamp'],
      taskDeleteBy: json['task_delete_by'],
      taskDeleteById: json['task_delete_by_id'],
      taskDeleteByDate: json['task_delete_by_date'],
      taskDeleteByTimestamp: json['task_delete_by_timestamp'],
      sourceFrom: json['source_from'],
      assignTo: json['assign_to'],
      company: json['company'],
      documentNumber: json['document_number'],
      category_name: json['category_name'],
      category: json['category'],
    );
  }
}



class Task {
  String taskId;
  String taskTitle;
  String taskType;
  String dueDate;
  String taskTypeName;
  String taskDescription;
  String taskCreateById;
  String taskCreateBy;
  String taskCreateDate;
  String taskCreateMonth;
  String taskCreatedTimestamp;
  String taskStatus;
  String taskStatusName;
  String actionTakenById;
  String actionTakenBy;
  String actionTakenDate;
  String actionTakenTimestamp;
  String taskReopenBy;
  String taskReopenById;
  String taskReopenDate;
  String taskReopenTimestamp;
  String taskFinishedBy;
  String taskFinishedById;
  String taskFinishedByDate;
  String taskFinishedByTimestamp;
  String taskEditBy;
  String taskEditById;
  String taskEditByDate;
  String taskEditByTimestamp;
  String taskDeleteBy;
  String taskDeleteById;
  String taskDeleteByDate;
  String taskDeleteByTimestamp;
  String sourceFrom;
  String assignTo;
  String company;
  String documentNumber;
  String watchList;
  String categoryName;
  String category;

  Task({
    required this.taskId,
    required this.taskTitle,
    required this.taskType,
    required this.dueDate,
    required this.taskTypeName,
    required this.taskDescription,
    required this.taskCreateById,
    required this.taskCreateBy,
    required this.taskCreateDate,
    required this.taskCreateMonth,
    required this.taskCreatedTimestamp,
    required this.taskStatus,
    required this.taskStatusName,
    required this.actionTakenById,
    required this.actionTakenBy,
    required this.actionTakenDate,
    required this.actionTakenTimestamp,
    required this.taskReopenBy,
    required this.taskReopenById,
    required this.taskReopenDate,
    required this.taskReopenTimestamp,
    required this.taskFinishedBy,
    required this.taskFinishedById,
    required this.taskFinishedByDate,
    required this.taskFinishedByTimestamp,
    required this.taskEditBy,
    required this.taskEditById,
    required this.taskEditByDate,
    required this.taskEditByTimestamp,
    required this.taskDeleteBy,
    required this.taskDeleteById,
    required this.taskDeleteByDate,
    required this.taskDeleteByTimestamp,
    required this.sourceFrom,
    required this.assignTo,
    required this.company,
    required this.documentNumber,
    required this.watchList,
    required this.categoryName,
    required this.category,
  });



  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        taskId: json['task_id'],
        taskTitle: json['task_title'],
        taskType: json['task_type'],
        dueDate: json['due_date'],
        taskTypeName: json['task_type_name'],
        taskDescription: json['task_description'],
        taskCreateById: json['task_create_by_id'],
        taskCreateBy: json['task_create_by'],
        taskCreateDate: json['task_create_date'],
        taskCreateMonth: json['task_create_month'],
        taskCreatedTimestamp: json['task_created_timestamp'],
        taskStatus: json['task_status'],
        taskStatusName: json['task_status_name'],
        actionTakenById: json['action_taken_by_id'],
        actionTakenBy: json['action_taken_by'],
        actionTakenDate: json['action_taken_date'],
        actionTakenTimestamp: json['action_taken_timestamp'],
        taskReopenBy: json['task_reopen_by'],
        taskReopenById: json['task_reopen_by_id'],
        taskReopenDate: json['task_reopen_date'],
        taskReopenTimestamp: json['task_reopen_timestamp'],
        taskFinishedBy: json['task_finished_by'],
        taskFinishedById: json['task_finished_by_id'],
        taskFinishedByDate: json['task_finished_by_date'],
        taskFinishedByTimestamp: json['task_finished_by_timestamp'],
        taskEditBy: json['task_edit_by'],
        taskEditById: json['task_edit_by_id'],
        taskEditByDate: json['task_edit_by_date'],
        taskEditByTimestamp: json['task_edit_by_timestamp'],
        taskDeleteBy: json['task_delete_by'],
        taskDeleteById: json['task_delete_by_id'],
        taskDeleteByDate: json['task_delete_by_date'],
        taskDeleteByTimestamp: json['task_delete_by_timestamp'],
        sourceFrom: json['source_from'],
        assignTo: json['assign_to'],
        company: json['company'],
        documentNumber: json['document_number'],
        watchList: json['watch_list'],
        categoryName: json['category_name'],
        category: json['category']);
  }
}

class comment {
  String commentId;
  String taskId;
  String commnt;
  String commentCreateById;
  String commentCreateBy;
  String commentCreateDate;
  String commentCreatedTimestamp;
  String commentStatus;
  String commentEditBy;
  String commentEditById;
  String commentEditByDate;
  String commentEditByTimestamp;
  String commentDeleteBy;
  String commentDeleteById;
  String commentDeleteByDate;
  String commentDeleteByTimestamp;
  String commentAttachment;

  comment({
    required this.commentId,
    required this.taskId,
    required this.commnt,
    required this.commentCreateById,
    required this.commentCreateBy,
    required this.commentCreateDate,
    required this.commentCreatedTimestamp,
    required this.commentStatus,
    required this.commentEditBy,
    required this.commentEditById,
    required this.commentEditByDate,
    required this.commentEditByTimestamp,
    required this.commentDeleteBy,
    required this.commentDeleteById,
    required this.commentDeleteByDate,
    required this.commentDeleteByTimestamp,
    required this.commentAttachment,
  });

  factory comment.fromJson(Map<String, dynamic> json) {
    return comment(
        commentId: json['comment_id'],
        taskId: json['task_id'],
        commnt: json['comment'],
        commentCreateById: json['comment_create_by_id'],
        commentCreateBy: json['comment_create_by'],
        commentCreateDate: json['comment_create_date'],
        commentCreatedTimestamp: json['comment_created_timestamp'],
        commentStatus: json['comment_status'],
        commentEditBy: json['comment_edit_by'],
        commentEditById: json['comment_edit_by_id'],
        commentEditByDate: json['comment_edit_by_date'],
        commentEditByTimestamp: json['comment_edit_by_timestamp'],
        commentDeleteBy: json['comment_delete_by'],
        commentDeleteById: json['comment_delete_by_id'],
        commentDeleteByDate: json['comment_delete_by_date'],
        commentDeleteByTimestamp: json['comment_delete_by_timestamp'],
        commentAttachment: json['comment_attachment']);
  }
}

class TaskDetailsBox {
  String taskDescription;
  String taskId;

  TaskDetailsBox(this.taskDescription, this.taskId);
}


class TaskLog {
  // int id;
  String logId;
  String logSummary;
  String taskId;
  String taskName;
  String logType;
  String logDetails;
  String logCreateBy;
  String logCreateById;
  String logCreateByDate;
  String logCreateByMonth;
  String logCreateByYear;
  String logCreateByTimestamp;

  TaskLog({
    // this.id,
    required this.logId,
    required this.logSummary,
    required this.taskId,
    required this.taskName,
    required this.logType,
    required this.logDetails,
    required this.logCreateBy,
    required this.logCreateById,
    required this.logCreateByDate,
    required this.logCreateByMonth,
    required this.logCreateByYear,
    required this.logCreateByTimestamp,
  });

  factory TaskLog.fromJson(Map<String, dynamic> json) {
    return TaskLog(
      // id: json['id'],
        logId: json['log_id']??'',
        logSummary: json['log_summary']??'',
        taskId: json['task_id']??'',
        taskName: json['task_name']??'',
        logType: json['log_type'],
        logDetails: json['log_details']??'',
        logCreateBy: json['log_create_by']??'',
        logCreateById: json['log_create_by_id']??'',
        logCreateByDate: json['log_create_by_date']??'',
        logCreateByMonth: json['log_create_by_month']??'',
        logCreateByYear: json['log_create_by_year'] ?? '2023',
        logCreateByTimestamp: json['log_create_by_timestamp']??'');
  }
}

//
// TextButton(
// onPressed: () {
// if (filteredTasks[index].taskStatus == '0') {
// // markInProgressMainTask(widget.task.taskTitle,widget.userName,widget.firstName, widget.task.taskId);
// // Handle 'Mark In Progress' action
// } else if (filteredTasks[index].taskStatus == '1') {
// // markAsCompletedMainTask(widget.task.taskTitle,widget.userName,widget.firstName, widget.task.taskId);
// // Handle 'Mark As Complete' action
// }
// },
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text(
// filteredTasks[index].taskStatus == '0'
// ? 'Mark In Progress'
//     : 'Mark As Complete',
// style: TextStyle(
// fontSize: 14,
// color: filteredTasks[index].taskStatus == '0'
// ? Colors.blueAccent
//     : Colors.redAccent,
// ),
// ),
// ),
// ),