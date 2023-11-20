import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace_web/colors.dart';
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

  TextEditingController searchController = TextEditingController();
  TextEditingController searchByNameController = TextEditingController();
  List<MainTask> searchedTasks = [];

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

  Widget buildTaskListByCategory(String category) {
    List<MainTask> filteredTasks = mainTaskList
        .where(
            (task) => task.category_name == category || category == 'All Tasks')
        .toList();

    if (searchController.text.isNotEmpty) {
      filteredTasks = filteredTasks
          .where((task) => task.taskId
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    } else if (searchByNameController.text.isNotEmpty) {
      filteredTasks = filteredTasks
          .where((task) => task.taskTitle
              .toLowerCase()
              .contains(searchByNameController.text.toLowerCase()))
          .toList();
    }

    return Row(
      children: [
        Expanded(
          flex: 1,
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
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  width: 5,
                                  color: _getColorForTaskTypeName(
                                      filteredTasks[index].taskTypeName))),
                          color: filteredTasks[index].isContainerTapped
                              ? AppColor
                                  .appLightBlue // Change this to the desired color when tapped
                              : Colors.grey.shade200,
                        ),
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
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
                                    Text('ID: ${filteredTasks[index].taskId}'),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(Icons.person_pin_circle_rounded),
                                    Text('${filteredTasks[index].assignTo} '),
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
                                    Text(
                                      'Beneficiary: ${filteredTasks[index].company}',
                                      style: TextStyle(color: Colors.black87),
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
                                    Text(
                                      'Due Date: ${filteredTasks[index].dueDate}',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (filteredTasks[index].taskStatus ==
                                            '0') {
                                          // markInProgressMainTask(widget.task.taskTitle,widget.userName,widget.firstName, widget.task.taskId);
                                          // Handle 'Mark In Progress' action
                                        } else if (filteredTasks[index]
                                                .taskStatus ==
                                            '1') {
                                          // markAsCompletedMainTask(widget.task.taskTitle,widget.userName,widget.firstName, widget.task.taskId);
                                          // Handle 'Mark As Complete' action
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Text(
                                          filteredTasks[index].taskStatus == '0'
                                              ? 'Mark In Progress'
                                              : 'Mark As Complete',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: filteredTasks[index]
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
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: ListView.builder(
              itemCount: subTaskList.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight:
                      Radius.circular(50.0), // Adjust these values as needed
                      bottomRight:
                      Radius.circular(50.0), // Adjust these values as needed
                    ),

                    color:  Colors.grey.shade200,
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
                                width: 20,
                              ),
                              Icon(Icons.person_pin_circle_rounded),
                              Text(
                                  '${subTaskList[index].assignTo} '),
                              Icon(
                                Icons.double_arrow_rounded,color: _getColorForTaskTypeName(subTaskList[index].taskTypeName),
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
                                  padding:
                                  const EdgeInsets.all(0.0),
                                  child: Text(
                                    subTaskList[index]
                                        .taskStatus ==
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
                        print('open task');
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
    );
  }

  Widget buildAllTasksList() {
    List<MainTask> filteredTasks = [];

    if (searchController.text.isNotEmpty) {
      filteredTasks = mainTaskList
          .where((task) => task.taskId
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    } else if (searchByNameController.text.isNotEmpty) {
      filteredTasks = mainTaskList
          .where((task) => task.taskTitle
              .toLowerCase()
              .contains(searchByNameController.text.toLowerCase()))
          .toList();
    } else {
      filteredTasks =
          List.from(mainTaskList); // Show all tasks when no search query
    }

    return filteredTasks.isNotEmpty
        ? Row(
            children: [
              Expanded(
                flex: 3,
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
                                  child: Text(
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
                                          Text(
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
                                          Text(
                                            'Beneficiary: ${filteredTasks[index].company}',
                                            style: TextStyle(
                                                color: Colors.black87),
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
                                          Text(
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
                                                // markInProgressMainTask(widget.task.taskTitle,widget.userName,widget.firstName, widget.task.taskId);
                                                // Handle 'Mark In Progress' action
                                              } else if (filteredTasks[index]
                                                      .taskStatus ==
                                                  '1') {
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
                                                    : 'Mark As Complete',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: filteredTasks[index]
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
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: subTaskList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight:
                            Radius.circular(50.0), // Adjust these values as needed
                            bottomRight:
                            Radius.circular(50.0), // Adjust these values as needed
                          ),

                          color:  Colors.grey.shade200,
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
                                      width: 20,
                                    ),
                                    Icon(Icons.person_pin_circle_rounded),
                                    Text(
                                        '${subTaskList[index].assignTo} '),
                                    Icon(
                                      Icons.double_arrow_rounded,color: _getColorForTaskTypeName(subTaskList[index].taskTypeName),
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
                                        padding:
                                        const EdgeInsets.all(0.0),
                                        child: Text(
                                          subTaskList[index]
                                              .taskStatus ==
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
                              print('open task');
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
          )
        : Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("No matches found!!",style: TextStyle(color: Colors.redAccent,fontSize: 16),),
      ),
    ); // Return an empty container if no search results or query
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
      length: 6 + 1, // 7 categories + 'All Tasks'
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: AppColor.appBlue,
          title: Text(
            'CBS Workspace',
            style: TextStyle(
              color: AppColor.appBlue,
              fontSize: 20,
            ),
          ),
          actions: [
            Column(
              children: [
                Text(
                  '',
                  style: TextStyle(
                    color: AppColor.appBlue,
                  ),
                ),
                Text(
                  "$firstName $lastName",
                  style: TextStyle(color: AppColor.appBlue, fontSize: 18.0),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const ProfilePage();
                  },
                );
              },
              icon: Icon(
                Icons.account_circle_sharp,
                color: AppColor.appBlue,
              ),
            ),
          ],
          bottom: TabBar(
            indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(20.0), // Adjust these values as needed
                  topRight:
                      Radius.circular(20.0), // Adjust these values as needed
                ),
                color: AppColor.appGrey),
            labelColor: Colors.black,
            dividerColor: AppColor.appDarkBlue,
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
        body: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 350,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: TextField(
                    controller: searchByNameController,
                    onChanged: (String value) {
                      setState(() {
                        // Filter the mainTaskList based on the entered value
                        searchedTasks = mainTaskList
                            .where((task) => task.taskTitle
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchByNameController.clear();
                          setState(() {
                            searchedTasks = List.from(
                                mainTaskList); // Reset to show all tasks
                          });
                        },
                        icon: const Icon(Icons.cancel_rounded),
                      ),
                      hintText: 'Search by Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {});
                        },
                        icon: const Icon(Icons.arrow_forward),
                      ),
                      hintText: 'Search by Task ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
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
          ],
        ),
      ),
    );
  }
}
