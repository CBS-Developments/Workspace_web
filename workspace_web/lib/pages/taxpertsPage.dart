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
  String localAction = "";
  int unreadCount = 0;


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
        // Filter the submissions where 'active' is '1' before mapping them to Submission objects
        final tempList = submissionsJson
            .where((json) => json['active'] == '1') // Filter for active submissions
            .map((json) => Submission.fromJson(json))
            .toList();

        // Calculate unread submissions count
        final unreadCount = tempList.where((submission) => submission.readStatus == '0').length;

        setState(() {
          submissionsList = tempList;
          this.unreadCount = unreadCount; // Update unread count state
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



  Future<bool> updateAction(
      String email,
      String action,
      ) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "email": email,
      "actions": action,
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/updateAction.php";

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
          print('Action update Successful!'); // Close the dialog
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

  // When a submission is selected from the list
  void onSubmissionSelected(Submission submission) {
    setState(() {
      selectedSubmission = submission;
      localAction = submission.actions;
    });
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Row(
              children: [
                Text('Unread Submissions:  ',style: TextStyle(fontSize: 20,color: Colors.green),),
                Text('$unreadCount ',style: TextStyle(fontSize: 20,color: Colors.green,fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: IconButton(
                onPressed: () {
                  getSubmissionsList();
                },
                tooltip: 'Refresh',
                icon: Icon(Icons.refresh_rounded,color: Colors.green,)),
          )
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
                      color: submission.readStatus == '1' ? Colors.white : AppColor.circleGreen,
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(
                            submission.readStatus == '1' ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                            color: submission.readStatus == '1' ? Colors.green : Colors.green,
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
                            onSubmissionSelected(submission);
                          });
                        },
                      ),
                    ),
                    Divider(color: Colors.green),
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
          color: Colors.grey.shade300, // Lighter border for a softer look
          width: 1.0,
        ),
        boxShadow: [ // Add a subtle shadow
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'Submission Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.green, // Use a theme color for headings
                ),
              ),
            ),
            SizedBox(height: 10),
            detailText('Name: ', submission.name, Icons.person),
            detailText('Tax Type: ', submission.taxType, Icons.business_center),
            detailText('Email: ', submission.email, Icons.email,),
            detailText('Phone: ', submission.phone, Icons.phone),
            detailText('TIN: ', submission.tin, Icons.vpn_key),
            detailText('Message: ', submission.message, Icons.message),
            detailText('From: ', submission.from, Icons.map),
            detailText('Device: ', submission.device, Icons.devices),
            detailText('Action: ', localAction, Icons.check_circle_outline),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: actionController,
                    maxLines: 1,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter your action',
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),

                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Check if the actionController's text is not empty
                      if (actionController.text.trim().isNotEmpty) {
                        bool success = await updateAction(submission.email, actionController.text.trim());
                        if(success) {
                          setState(() {
                            // Set localAction to the new action after successful update
                            localAction = actionController.text.trim();
                          });
                          actionController.clear(); // Clear the controller if it's not empty
                        } else {
                          // Handle update failure (e.g., show an error message)
                          print('Failed to update action');
                        }
                      } else {
                        // Here you can handle the case where the actionController is empty
                        // For example, show a message to the user indicating that the input cannot be empty.
                        print('The input is empty');
                      }
                    },

                    // Icon for the button
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // Background color
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget detailText(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green.shade700), // Icon for each detail
          SizedBox(width: 10),
          Expanded(
            child: SelectableText.rich(
              TextSpan(
                text: "$label ", // Label text
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold, // Make label bold
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: value, // Value text
                    style: TextStyle(
                      fontWeight: FontWeight.normal, // Regular weight for value
                    ),
                  ),
                ],
              ),
              // Additional styling and behavior options
              style: TextStyle(
                fontSize: 16, // Base font size
                color: Colors.black, // Base text color
              ),
              cursorColor: Colors.blue, // Cursor color when text is selected
              showCursor: true, // Show cursor when text field is focused
              toolbarOptions: ToolbarOptions( // Toolbar options for copy, cut, paste, select all
                copy: true,
                selectAll: true,
                cut: false,
                paste: false,
              ),
            ),
          )

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
