import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../colors.dart';
import '../componants.dart';

class TaskLogPage extends StatefulWidget {
  const TaskLogPage({Key? key}) : super(key: key);

  @override
  State<TaskLogPage> createState() => _TaskLogPageState();
}

class _TaskLogPageState extends State<TaskLogPage> {
  List<TaskLog> logList = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchTodayLogs();
  }

  Future<List<TaskLog>> getLogList(DateTime selectedDate) async {
    var data = {
      'selectedDate': selectedDate.toLocal().toString(),
    };

    const url = "http://dev.workspace.cbs.lk/taskLogList.php";
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
      List<TaskLog> logs = [];
      for (Map<String, dynamic> details in responseJson) {
        logs.add(TaskLog.fromJson(details));
      }
      return logs;
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  List<TaskLog> filterTaskLog(List<TaskLog>? data, DateTime selectedDate) {
    final formatter = DateFormat('yyyy-MM-dd');
    final selectedDateStr = formatter.format(selectedDate);

    return data
        ?.where((log) => log.logCreateByDate == selectedDateStr)
        .toList() ??
        [];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      List<TaskLog> selectedDateLogs = await getLogList(selectedDate);
      List<TaskLog> filteredLogs = filterTaskLog(selectedDateLogs, selectedDate);

      setState(() {
        logList = filteredLogs;
      });
    }
  }

  Future<void> _fetchTodayLogs() async {
    DateTime today = DateTime.now();
    List<TaskLog> todayLogs = await getLogList(today);
    List<TaskLog> filteredLogs = filterTaskLog(todayLogs, today);

    setState(() {
      logList = filteredLogs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Center(
          child: Text(
            'Task Log',
            style: TextStyle(
              color: AppColor.appBlue,
              fontSize: 20,
            ),
          ),
        ),
      ),
      drawer: MyDrawer(),
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Column(
                children: [],
              )),
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: _fetchTodayLogs,
                          style: ElevatedButton.styleFrom(
                            primary: AppColor.appDarkBlue, // Change the color to your desired one
                          ),
                          child: Text(
                            "Today Task Log",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: AppColor.appDarkBlue, // Change the color to your desired one
                                  ),
                                  child: Text("Select Previous Date :"),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Text(
                              "Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: logList.isEmpty
                        ? const Center(
                      child: Text(
                        'There is no Log List to show!!',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    )
                        : ListView.builder(
                      itemCount: logList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: ListTile(
                            title: Text(
                              '${logList[index].logCreateBy} ${logList[index].logSummary} ${logList[index].logType} : ${logList[index].taskName} as: ${logList[index].logDetails} ',
                            ),
                            subtitle: Text(logList[index].logId),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                children: [],
              )),
        ],
      ),
    );
  }
}
