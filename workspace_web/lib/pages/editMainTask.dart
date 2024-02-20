import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';
import '../componants.dart';
import '../sizes.dart';
import 'openMainTask.dart';

class EditMainTaskPage extends StatefulWidget {
  final MainTask mainTaskDetails;
  const EditMainTaskPage({super.key, required this.mainTaskDetails});

  @override
  State<EditMainTaskPage> createState() => _EditMainTaskPageState();
}

class _EditMainTaskPageState extends State<EditMainTaskPage> {
  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String priority = '';
  String dueDate = '';
  String sourceFrom =
      ''; // Set a default value that exists in the dropdown items
  String assignTo = ''; // Default value from the items list
  String beneficiary = ''; // Default value from the items list
  String categoryName = ''; // Default value from the items list
  String category = ''; // Default value from the items list
  int selectedIndex = -1; // Default index value // Default index value

  List<String> selectedAssignTo = [];

  List<String> categoryNames = [
    'Taxation - TAS',
    'Talent Management - TMS',
    'Finance & Accounting - AFSS',
    'Audit & Assurance - ASS',
    'Company Secretarial - CSS',
    'Development - DEV'
    // Add your category items here
  ];

  List<String> beneficiaryNames = [];
  int beneficiaryNamesCount = 0;

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

  String getCurrentMonth() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yy-MM').format(now);
    return formattedDate;
  }

  String generatedTaskId() {
    final random = Random();
    int min = 1; // Smallest 9-digit number
    int max = 999999999; // Largest 9-digit number
    int randomNumber = min + random.nextInt(max - min + 1);
    return randomNumber.toString().padLeft(9, '0');
  }

  @override
  void initState() {
    super.initState();
    // Initialize assignTo based on selectedAssignTo
    // assignTo = selectedAssignTo.toString();
    loadData();
    getBeneficiaryList();
    beneficiary = widget.mainTaskDetails.company;
    priority = widget.mainTaskDetails.taskTypeName;
    sourceFrom = widget.mainTaskDetails.sourceFrom;
    assignTo = widget.mainTaskDetails.assignTo;
    categoryName = widget.mainTaskDetails.category_name;
    category = widget.mainTaskDetails.category;
    titleController.text = widget.mainTaskDetails.taskTitle;
    descriptionController.text = widget.mainTaskDetails.task_description;
    dueDate = widget.mainTaskDetails.dueDate;
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "";
      firstName = prefs.getString('first_name') ?? "";
      lastName = prefs.getString('last_name') ?? "";
      phone = prefs.getString('phone') ?? "";
      userRole = prefs.getString('user_role') ?? "";
      print(
          'Data laded in create main task > userName: $userName > userRole: $userRole');
    });
  }

  Future<void> getBeneficiaryList() async {
    beneficiaryNames.clear();
    var data = {};

    const url = "http://dev.workspace.cbs.lk/getBeneficiaries.php";
    final res = await http.post(
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
          BeneficiaryF beneficiary = BeneficiaryF.fromJson(details);
          beneficiaryNames.add(beneficiary
              .fullName); // Add the full name of the beneficiary to the list
        }
      });
      print("beneficiaryNames Count: ${beneficiaryNames.length}");
    } else {
      throw Exception('Failed to load users from API');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      // Define the desired date format
      final DateFormat formatter =
          DateFormat('yyyy-MM-dd'); // Example format: yyyy-MM-dd

      setState(() {
        // Format the picked date using the defined format
        dueDate = formatter.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Center(
            child: Text('Editing Main Task: ${widget.mainTaskDetails.taskId}')),
      ),
      body: Row(
        children: [
          const Expanded(flex: 1, child: Column()),
          Expanded(
            flex: 4,
            child: SizedBox(
              height: getPageHeight(context),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey, // Shadow color
                            blurRadius: 5, // Spread radius
                            offset:
                                Offset(0, 3), // Offset in x and y directions
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(00),
                                color: AppColor.appGrey),
                            child: TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                labelText: 'Title: ',
                                labelStyle: TextStyle(
                                    color: AppColor.appDarkBlue, fontSize: 20),
                                hintText: 'Enter main task title',
                                hintStyle: const TextStyle(fontSize: 14),
                                // Change border and focused border colors
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .lightBlueAccent), // Normal border color
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          AppColor.appDarkBlue), // Focus color
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(00),
                                color: AppColor.appGrey),
                            child: TextField(
                              controller: descriptionController,
                              maxLines: null,
                              decoration: InputDecoration(
                                labelText: 'Description: ',
                                labelStyle: TextStyle(
                                    color: AppColor.appDarkBlue, fontSize: 20),
                                hintText: 'Enter task description',
                                hintStyle: const TextStyle(fontSize: 14),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .lightBlueAccent), // Normal border color
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          AppColor.appDarkBlue), // Focus color
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Beneficiary:  ",
                                        style: TextStyle(
                                            color: AppColor.appDarkBlue,
                                            fontSize: 18),
                                      ),
                                      Expanded(
                                        child: Autocomplete<String>(
                                          optionsBuilder: (TextEditingValue
                                              textEditingValue) {
                                            return beneficiaryNames
                                                .where((String option) {
                                              return option
                                                  .toLowerCase()
                                                  .contains(
                                                    textEditingValue.text
                                                        .toLowerCase(),
                                                  );
                                            });
                                          },
                                          onSelected: (String value) {
                                            setState(() {
                                              beneficiary = value;
                                            });
                                          },
                                          fieldViewBuilder: (BuildContext
                                                  context,
                                              TextEditingController
                                                  textEditingController,
                                              FocusNode focusNode,
                                              VoidCallback onFieldSubmitted) {
                                            return TextField(
                                              controller: textEditingController,
                                              focusNode: focusNode,
                                              onChanged: (String text) {
                                                // Perform search or filtering here
                                              },
                                              decoration: InputDecoration(
                                                hintText:
                                                    '${widget.mainTaskDetails.company}',
                                                hintStyle: const TextStyle(
                                                    fontSize: 16),
                                                enabledBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .lightBlueAccent), // Normal border color
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColor
                                                          .appDarkBlue), // Focus color
                                                ),
                                              ),
                                            );
                                          },
                                          optionsViewBuilder: (
                                            BuildContext context,
                                            AutocompleteOnSelected<String>
                                                onSelected,
                                            Iterable<String> options,
                                          ) {
                                            return Align(
                                              alignment: Alignment.topLeft,
                                              child: Material(
                                                elevation: 4.0,
                                                child: Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxHeight: 200),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.55,
                                                  child: ListView(
                                                    children: options
                                                        .map((String option) =>
                                                            ListTile(
                                                              title:
                                                                  Text(option),
                                                              onTap: () {
                                                                onSelected(
                                                                    option);
                                                              },
                                                            ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Expanded(
                                flex: 2,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 18.0),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Due Date:  ",
                                        style: TextStyle(
                                            color: AppColor.appDarkBlue,
                                            fontSize: 18),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _selectDate(context);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              dueDate.isEmpty
                                                  ? 'Select Date'
                                                  : 'Selected Date: $dueDate',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Icon(
                                                Icons.calendar_month_rounded,
                                                color: Colors.black87,
                                                size: 16,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(flex: 3, child: Container()),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 5),
                                  child: MultiSelectFormField(
                                    autovalidate: AutovalidateMode.always,
                                    title: Text(
                                      'Assign To: ',
                                      style: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 18),
                                    ),
                                    dataSource: const [
                                      {
                                        "display": "Deshika",
                                        "value": "Deshika",
                                      },
                                      {
                                        "display": "Damith",
                                        "value": "Damith",
                                      },
                                      {
                                        "display": "Iqlas",
                                        "value": "Iqlas",
                                      },
                                      {
                                        "display": "Udari",
                                        "value": "Udari",
                                      },
                                      {
                                        "display": "Shahiru",
                                        "value": "Shahiru",
                                      },
                                      {
                                        "display": "Dinethri",
                                        "value": "Dinethri",
                                      },
                                      {
                                        "display": "Sulakshana",
                                        "value": "Sulakshana",
                                      },
                                      {
                                        "display": "Samadhi",
                                        "value": "Samadhi",
                                      },
                                      {
                                        "display": "Sanjana",
                                        "value": "Sanjana",
                                      },
                                      // Add other items as needed
                                    ],
                                    textField: 'display',
                                    hintWidget: Text(
                                        '${widget.mainTaskDetails.assignTo}'),
                                    valueField: 'value',
                                    okButtonLabel: 'OK',
                                    cancelButtonLabel: 'CANCEL',
                                    initialValue: selectedAssignTo,
                                    onSaved: (value) {
                                      if (value == null) return;
                                      setState(() {
                                        selectedAssignTo = value.cast<
                                            String>(); // Ensure the value is a list of strings
                                        assignTo = selectedAssignTo.toString();
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(flex: 2, child: Container()),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Priority:  ",
                                        style: TextStyle(
                                            color: AppColor.appDarkBlue,
                                            fontSize: 18),
                                      ),
                                      Expanded(
                                        child: Autocomplete<String>(
                                          optionsBuilder: (TextEditingValue
                                              textEditingValue) {
                                            return [
                                              'Top Urgent',
                                              'Medium',
                                              'Regular',
                                              'Low'
                                            ].where((String option) {
                                              return option
                                                  .toLowerCase()
                                                  .contains(
                                                    textEditingValue.text
                                                        .toLowerCase(),
                                                  );
                                            });
                                          },
                                          onSelected: (String value) {
                                            setState(() {
                                              priority = value;
                                            });
                                          },
                                          fieldViewBuilder: (
                                            BuildContext context,
                                            TextEditingController
                                                textEditingController,
                                            FocusNode focusNode,
                                            VoidCallback onFieldSubmitted,
                                          ) {
                                            return TextField(
                                              controller: textEditingController,
                                              focusNode: focusNode,
                                              onChanged: (String text) {
                                                // Perform search or filtering here
                                              },
                                              decoration: InputDecoration(
                                                hintText:
                                                    '${widget.mainTaskDetails.taskTypeName}',
                                                hintStyle: const TextStyle(
                                                    fontSize: 16),
                                                enabledBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .lightBlueAccent), // Normal border color
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColor
                                                          .appDarkBlue), // Focus color
                                                ),
                                              ),
                                            );
                                          },
                                          optionsViewBuilder: (
                                            BuildContext context,
                                            AutocompleteOnSelected<String>
                                                onSelected,
                                            Iterable<String> options,
                                          ) {
                                            return Align(
                                              alignment: Alignment.topLeft,
                                              child: Material(
                                                elevation: 4.0,
                                                child: Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxHeight: 200),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  child: ListView(
                                                    children: options
                                                        .map((String option) =>
                                                            ListTile(
                                                              title:
                                                                  Text(option),
                                                              onTap: () {
                                                                onSelected(
                                                                    option);
                                                              },
                                                            ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(flex: 2, child: Container())
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Source From:  ",
                                        style: TextStyle(
                                            color: AppColor.appDarkBlue,
                                            fontSize: 18),
                                      ),
                                      Expanded(
                                        child: Autocomplete<String>(
                                          optionsBuilder: (TextEditingValue
                                              textEditingValue) {
                                            return [
                                              'Skype',
                                              'Corporate Email',
                                              'Emojot Email',
                                              'On Call',
                                              'Company Chat',
                                              'Other',
                                            ].where((String option) {
                                              return option
                                                  .toLowerCase()
                                                  .contains(
                                                    textEditingValue.text
                                                        .toLowerCase(),
                                                  );
                                            });
                                          },
                                          onSelected: (String value) {
                                            setState(() {
                                              sourceFrom = value;
                                            });
                                          },
                                          fieldViewBuilder: (
                                            BuildContext context,
                                            TextEditingController
                                                textEditingController,
                                            FocusNode focusNode,
                                            VoidCallback onFieldSubmitted,
                                          ) {
                                            return TextField(
                                              controller: textEditingController,
                                              focusNode: focusNode,
                                              onChanged: (String text) {
                                                // Perform search or filtering here
                                              },
                                              decoration: InputDecoration(
                                                hintText:
                                                    '${widget.mainTaskDetails.sourceFrom}',
                                                hintStyle: const TextStyle(
                                                    fontSize: 16),
                                                enabledBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .lightBlueAccent), // Normal border color
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColor
                                                          .appDarkBlue), // Focus color
                                                ),
                                              ),
                                            );
                                          },
                                          optionsViewBuilder: (
                                            BuildContext context,
                                            AutocompleteOnSelected<String>
                                                onSelected,
                                            Iterable<String> options,
                                          ) {
                                            return Align(
                                              alignment: Alignment.topLeft,
                                              child: Material(
                                                elevation: 4.0,
                                                child: Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxHeight: 200),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.35,
                                                  child: ListView(
                                                    children: options
                                                        .map((String option) =>
                                                            ListTile(
                                                              title:
                                                                  Text(option),
                                                              onTap: () {
                                                                onSelected(
                                                                    option);
                                                              },
                                                            ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(flex: 2, child: Container())
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Category:  ",
                                        style: TextStyle(
                                            color: AppColor.appDarkBlue,
                                            fontSize: 18),
                                      ),
                                      Expanded(
                                        child: Autocomplete<String>(
                                          optionsBuilder: (TextEditingValue
                                              textEditingValue) {
                                            return categoryNames
                                                .where((String option) {
                                              return option
                                                  .toLowerCase()
                                                  .contains(
                                                    textEditingValue.text
                                                        .toLowerCase(),
                                                  );
                                            });
                                          },
                                          onSelected: (String value) {
                                            setState(() {
                                              categoryName = value;
                                              selectedIndex =
                                                  categoryNames.indexOf(value);
                                              category = selectedIndex
                                                  .toString(); // Convert selectedIndex to string
                                            });
                                          },
                                          fieldViewBuilder: (
                                            BuildContext context,
                                            TextEditingController
                                                textEditingController,
                                            FocusNode focusNode,
                                            VoidCallback onFieldSubmitted,
                                          ) {
                                            return TextField(
                                              controller: textEditingController,
                                              focusNode: focusNode,
                                              onChanged: (String text) {
                                                // Perform search or filtering here
                                              },
                                              decoration: InputDecoration(
                                                hintText: widget.mainTaskDetails
                                                    .category_name,
                                                hintStyle: const TextStyle(
                                                    fontSize: 16),
                                                enabledBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .lightBlueAccent), // Normal border color
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColor
                                                          .appDarkBlue), // Focus color
                                                ),
                                              ),
                                            );
                                          },
                                          optionsViewBuilder: (
                                            BuildContext context,
                                            AutocompleteOnSelected<String>
                                                onSelected,
                                            Iterable<String> options,
                                          ) {
                                            return Align(
                                              alignment: Alignment.topLeft,
                                              child: Material(
                                                elevation: 4.0,
                                                child: Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxHeight: 100),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  child: ListView(
                                                    children: options
                                                        .map((String option) =>
                                                            ListTile(
                                                              title:
                                                                  Text(option),
                                                              onTap: () {
                                                                onSelected(
                                                                    option);
                                                              },
                                                            ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(flex: 2, child: Container())
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: AppColor
                                      .appDarkBlue, // Change this to the desired color
                                ),
                                onPressed: () {
                                  editMainTask();
                                  print('Title:${titleController.text}');
                                  print(
                                      'Description:${descriptionController.text}');
                                  print('Selected Priority:$priority');
                                  print('Selected Due Date:$dueDate');
                                  print('Selected Source From:$sourceFrom');
                                  print('Selected Assign To:$assignTo');
                                  print('Selected Beneficiary:$beneficiary');
                                  print('Selected Category Name:$categoryName');
                                  print('Selected Category:$category');
                                },
                                child: const Text('Save Changes'),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors
                                      .redAccent, // Change this to the desired color
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OpenMainTaskPage(
                                              taskDetails:
                                                  widget.mainTaskDetails,
                                            ) // Pass the task details
                                        ),
                                  );
                                },
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Expanded(flex: 1, child: Column())
        ],
      ),
    );
  }

  Future<bool> editMainTask() async {
    String logType = 'Main Task';
    String logSummary = 'Edited';
    String logDetails = '';
    var data = {
      "task_id": widget.mainTaskDetails.taskId,
      "task_title": titleController.text,
      "task_type_name": priority,
      "task_description": descriptionController.text,
      "task_status_name": widget.mainTaskDetails.taskStatusName,
      "action_taken_by_id": userName,
      "action_taken_by": firstName,
      "action_taken_date": getCurrentDate(),
      "action_taken_timestamp": getCurrentDate(),
      "task_edit_by": userName,
      "task_edit_by_id": firstName,
      "task_edit_by_date": getCurrentDate(),
      "task_edit_by_timestamp": getCurrentDate(),
      "company": beneficiary,
      "due_date": dueDate,
      "assign_to": assignTo,
      "source_from": sourceFrom,
      "category_name": categoryName,
      "category": category,
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/editMainTask.php";

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
          print('Main task edit Successful');
          addLog(context,
              taskId: widget.mainTaskDetails.taskId,
              taskName: widget.mainTaskDetails.taskTitle,
              createBy: firstName,
              createByID: userName,
              logType: logType,
              logSummary: logSummary,
              logDetails: logDetails);
          snackBar(context, " Edit Main Task successful!", Colors.green);
          Navigator.pushNamed(context, '/Task');

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

  Future<void> addLog(BuildContext context,
      {required String taskId,
      required String taskName,
      required String createBy,
      required String createByID,
      required String logType,
      required String logSummary,
      required String logDetails}) async {
    var url = "http://dev.workspace.cbs.lk/addLogUpdate.php";

    var data = {
      "log_id": getCurrentDateTime(),
      "task_id": taskId,
      "task_name": taskName,
      "log_summary": logSummary,
      "log_type": logType,
      "log_details": logDetails,
      "log_create_by": createBy,
      "log_create_by_id": createByID,
      "log_create_by_date": getCurrentDate(),
      "log_create_by_month": getCurrentMonth(),
      "log_create_by_year": '',
      "log_created_by_timestamp": getCurrentDateTime(),
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
        if (!mounted) return;
        print('Log added!!');
      } else {
        if (!mounted) return;
        snackBar(context, "Error", Colors.red);
      }
    } else {
      if (!mounted) return;
      snackBar(context, "Error", Colors.redAccent);
    }
  }
}
