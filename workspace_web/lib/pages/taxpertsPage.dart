import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../colors.dart'; // Your AppColor definitions
import '../componants.dart'; // Your custom Drawer and possibly other components

class TaxpertsPage extends StatefulWidget {
  const TaxpertsPage({super.key});

  @override
  State<TaxpertsPage> createState() => _TaxpertsPageState();
}

class _TaxpertsPageState extends State<TaxpertsPage> {
  List<Submission> submissionsList = [];
  Submission? selectedSubmission;
  TextEditingController actionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSubmissionsList();
  }

  Future<void> getSubmissionsList() async {
    const url = "http://dev.workspace.cbs.lk/submissionList.php";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List submissionsJson = json.decode(response.body);
        setState(() {
          // Filter the submissions where 'active' is '1' before mapping them to Submission objects
          submissionsList = submissionsJson
              .where((json) =>
                  json['active'] == '1') // Filter for active submissions
              .map((json) => Submission.fromJson(json))
              .toList();
        });
      } else {
        // Handle server errors
        print('Server error: ${response.body}');
      }
    } catch (e) {
      // Handle network errors
      print('Error fetching submissions: $e');
    }
  }

  void showRemoveConfirmationDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Remove'),
          content: const Text('Are you sure you want to remove this Submission?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                removeSubmission(email);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> removeSubmission(
    String email,
  ) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "email": email,
      "active": '0',
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/removeSubmissions.php";

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
          print('Remove Successful');
          Navigator.of(context).pop(); // Close the dialog
          getSubmissionsList();

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

  Future<bool> markAsRead(
      String email,
      ) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "email": email,
      "read_status": '1',
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/readStatus.php";

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
          print('Mark as read Successful'); // Close the dialog
          getSubmissionsList();

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


  Future<bool> markAsUnRead(
      String email,
      ) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "email": email,
      "read_status": '0',
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/readStatus.php";

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
          print('Mark as unread Successful'); // Close the dialog
          getSubmissionsList();

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Text(
          'Taxperts Submissions',
          style: TextStyle(
            color: AppColor.appBlue,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                getSubmissionsList();
              },
              tooltip: 'Refresh',
              icon: Icon(Icons.refresh_rounded))
        ],
      ),
      drawer: MyDrawer(), // Your custom Drawer
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: submissionsList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: submissionsList.length,
              itemBuilder: (context, index) {
                final submission = submissionsList[index];
                return Column(
                  children: [
                    Container(
                      color: submission.readStatus == '1' ? Colors.white : AppColor.appGrey,
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(
                            submission.readStatus == '1' ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                            color: submission.readStatus == '1' ? Colors.green : Colors.blueAccent,
                          ),
                          tooltip: submission.readStatus == '1' ? 'Mark as unread' : 'Mark as read',
                          onPressed: () {
                            if (submission.readStatus == '1') {
                              // Call markAsUnRead for this submission
                              markAsUnRead(submission.email);
                            } else {
                              // Call markAsRead for this submission
                              markAsRead(submission.email);
                            }
                          },
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            showRemoveConfirmationDialog(context, submission.email);
                          },
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: Colors.redAccent,
                          ),
                        ),
                        title: Text(
                          submission.name,
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text("From: ${submission.from}"),
                        onTap: () {
                          setState(() {
                            selectedSubmission = submission;
                          });
                        },
                      ),
                    ),
                    Divider(color: AppColor.appBlue),
                  ],
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: selectedSubmission == null
                ? Center(child: Text('Select a submission'))
                : submissionDetails(selectedSubmission!),
          ),
        ],
      ),
    );
  }

  Widget submissionDetails(Submission submission) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      margin: EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade500,
          width: 1.0,
        ),
      ),
      child: SingleChildScrollView(
        // Use SingleChildScrollView to handle overflow
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Submission Details:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            detailText('Name:', submission.name),
            detailText('Tax Type:', submission.taxType),
            detailText('Email:', submission.email),
            detailText('Phone:', submission.phone),
            detailText('TIN:', submission.tin),
            detailText('Message:', submission.message),
            detailText('From:', submission.from),
            detailText('Device:', submission.device),
            detailText('Action:', submission.actions),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 300,
                  height: 40,
                  child: TextField(
                    controller: actionController,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter your action',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(onPressed: () {}, child: Text('Save')),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget detailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$label $value",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class Submission {
  final String name;
  final String taxType;
  final String email;
  final String phone;
  final String tin;
  final String message;
  final String from;
  final String device;
  final String active;
  final String readStatus;
  final String actions;

  Submission({
    required this.name,
    required this.taxType,
    required this.email,
    required this.phone,
    required this.tin,
    required this.message,
    required this.from,
    required this.device,
    required this.active,
    required this.readStatus,
    required this.actions,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      name: json['name_'],
      taxType: json['tax_type'],
      email: json['email'],
      phone: json['phone'],
      tin: json['tin'],
      message: json['message_'],
      from: json['from_'],
      device: json['device'],
      active: json['active'],
      readStatus: json['read_status'],
      actions: json['actions'],
    );
  }
}
