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
          submissionsList = submissionsJson.map((json) => Submission.fromJson(json)).toList();
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
        actions: [],
      ),
      drawer: MyDrawer(), // Your custom Drawer
      body: Row(
        children: [
          Expanded(
            child: submissionsList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: submissionsList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(submissionsList[index].name,style: TextStyle(fontSize: 18),),
                  subtitle: Text("From: ${submissionsList[index].from}"),
                  onTap: () {
                    setState(() {
                      selectedSubmission = submissionsList[index];
                    });
                  },
                );
              },
            ),
          ),
          Expanded(
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
      child: SingleChildScrollView( // Use SingleChildScrollView to handle overflow
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
            detailText('Actions:', submission.actions),
            SizedBox(height: 20),
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
