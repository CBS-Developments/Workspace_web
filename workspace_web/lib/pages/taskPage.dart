import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace_web/pages/profilePage.dart';

import '../componants.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<MainTask> mainTaskList = [];
  List<Task> subTaskList = [];
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


  Widget buildTaskListByCategory(String category) {
    List<MainTask> filteredTasks = mainTaskList
        .where((task) => task.category_name == category || category == 'All Tasks')
        .toList();

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredTasks[index].taskTitle),
                  onTap: () {
                    String mainTaskId = filteredTasks[index].taskId;
                    getSubTaskListByMainTaskId(mainTaskId);
                  },
                );
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: ListView.builder(
              itemCount: subTaskList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(subTaskList[index].taskTitle),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAllTasksList() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: ListView.builder(
              itemCount: mainTaskList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(mainTaskList[index].taskTitle),
                  onTap: () {
                    String mainTaskId = mainTaskList[index].taskId;
                    getSubTaskListByMainTaskId(mainTaskId);
                  },
                );
              },
            ),
          ),
        ),

        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: ListView.builder(
              itemCount: subTaskList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(subTaskList[index].taskTitle),
                );
              },
            ),
          ),
        ),
      ],
    );
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
    return DefaultTabController(
      length: 6+ 1, // 7 categories + 'All Tasks'
      child: Scaffold(
        appBar: AppBar(
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

          bottom: TabBar(
            dividerColor: Colors.teal,
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'All Tasks'),
              Tab(text: 'Taxation - TAS'),
              Tab(text: 'Talent Management - TMS'),
              Tab(text: 'Finance & Accounting - AFSS'),
              Tab(text: 'Audit & Assurance - ASS'),
              Tab(text: 'Company Secretarial - CSS'),
              Tab(text: 'Development - DEV'),

            ],
          ),
        ),
        drawer: MyDrawer(),
        body: TabBarView(
          children: [
            buildAllTasksList(),
            buildTaskListByCategory('Taxation - TAS'),
            buildTaskListByCategory('Talent Management - TMS'),
            buildTaskListByCategory('Finance & Accounting - AFSS'),
            buildTaskListByCategory('Audit & Assurance - ASS'),
            buildTaskListByCategory('Company Secretarial - CSS'),
            buildTaskListByCategory('Development - DEV'),

          ],
        ),
      ),
    );
  }
}