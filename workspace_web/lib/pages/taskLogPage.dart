import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../colors.dart';
import '../componants.dart';

class TaskLogPage extends StatefulWidget {
  const TaskLogPage({super.key});

  @override
  State<TaskLogPage> createState() => _TaskLogPageState();
}

class _TaskLogPageState extends State<TaskLogPage>  {
  List<TaskLog> logList = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getLogList();
  }

  Future<void> getLogList() async {
    logList.clear();
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
      setState(() {
        for (Map<String, dynamic> details in responseJson) {
          logList.add(TaskLog.fromJson(details));
        }
      });
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  List<TaskLog> filterTaskLog(List<TaskLog>? data, DateTime selectedDate) {
    final formatter = DateFormat('yyyy-MM-dd');
    final selectedDateStr = formatter.format(selectedDate);

    // Filter based on selected date
    return data?.where((log) => log.logCreateByDate == selectedDateStr).toList() ?? [];
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

      // Filter based on selected date when date changes
      await getLogList();
      logList = filterTaskLog(logList, selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Text(
          'Task Log',
          style: TextStyle(
            color: AppColor.appBlue,
            fontSize: 20,
          ),
        ),
      ),
      drawer: MyDrawer(),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    color: AppColor.appDarkBlue,
                    child: TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text(
                        'Select Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: logList.isEmpty
                      ? const Center(
                    child: Text(
                      'There is no Log List found!!',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  )
                      : ListView.builder(
                    itemCount: logList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: ListTile(
                          title: Text(
                              '${logList[index].logCreateBy} ${logList[index].logSummary} ${logList[index].logType} : ${logList[index].taskName} as: ${logList[index].logDetails} '),
                          subtitle: Text(logList[index].logId),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            flex: 1,
            child: Column(),
          ),
        ],
      ),
    );
  }
}

