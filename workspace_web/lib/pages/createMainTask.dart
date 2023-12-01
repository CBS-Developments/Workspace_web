import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../colors.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class CreateMainTask extends StatefulWidget {
  const CreateMainTask({Key? key}) : super(key: key);

  @override
  _CreateMainTaskState createState() => _CreateMainTaskState();
}

class _CreateMainTaskState extends State<CreateMainTask> {
  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";



  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String priority = '';
  String dueDate = '';
  String sourceFrom = ''; // Set a default value that exists in the dropdown items
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

  List<String> beneficiaries = [
    'Beneficiary A',
    'Beneficiary B',
    'Beneficiary C',
    'Beneficiary D',
    'Beneficiary E',
    'Beneficiary F',
  ];
  @override
  void initState() {
    super.initState();
    // Initialize assignTo based on selectedAssignTo
    assignTo = selectedAssignTo.join(', ');
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
      print(
          'Data laded in create main task > userName: $userName > userRole: $userRole');
    });
  }

  Future<void> createMainTask() async {
    // Validate input fields...
    // (existing validation code)

    // Your data preparation code here...

    var url = "http://dev.workspace.cbs.lk/mainTaskCreate.php";
    // ... (rest of your code for preparing data)

    // HTTP request handling...
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
      final DateFormat formatter = DateFormat('yyyy-MM-dd'); // Example format: yyyy-MM-dd

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
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Center(child: Text('Create Main Task')),
      ),
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Column()),
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey, // Shadow color
                    blurRadius: 5, // Spread radius
                    offset: Offset(0, 3), // Offset in x and y directions
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(00),
                      color: AppColor.appGrey
                    ),
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title: ',
                        labelStyle: TextStyle(color: AppColor.appDarkBlue,fontSize: 20),
                        hintText: 'Enter main task title',
                        hintStyle: TextStyle(fontSize: 14),
                        // Change border and focused border colors
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent), // Normal border color
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.appDarkBlue), // Focus color
                      ),
                    ),
                  ),
                  ),

                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(00),
                        color: AppColor.appGrey
                    ),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(color: AppColor.appDarkBlue,fontSize: 20),
                        hintText: 'Enter task description',
                        hintStyle: TextStyle(fontSize: 14),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent), // Normal border color
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.appDarkBlue), // Focus color
                        ),
                      ),
                    ),
                  ),




                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Row(
                          children: [
                            Text("Beneficiary:  ",style: TextStyle(color: AppColor.appDarkBlue,fontSize: 18),),
                            Expanded(
                              child: Autocomplete<String>(
                                optionsBuilder: (TextEditingValue textEditingValue) {
                                  return beneficiaries.where((String option) {
                                    return option.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase(),
                                    );
                                  });
                                },
                                onSelected: (String value) {
                                  setState(() {
                                    beneficiary = value;
                                  });
                                },
                                fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                                  return TextField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    onChanged: (String text) {
                                      // Perform search or filtering here
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Select beneficiary',
                                      hintStyle: TextStyle(fontSize: 16),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: AppColor.appDarkBlue), // Focus color
                                      ),
                                    ),
                                  );
                                },
                                optionsViewBuilder: (
                                    BuildContext context,
                                    AutocompleteOnSelected<String> onSelected,
                                    Iterable<String> options,
                                    ) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      elevation: 4.0,
                                      child: Container(
                                        constraints: BoxConstraints(maxHeight: 200),
                                        width: MediaQuery.of(context).size.width*0.55,
                                        child: ListView(
                                          children: options
                                              .map((String option) => ListTile(
                                            title: Text(option),
                                            onTap: () {
                                              onSelected(option);
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

                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Row(
                            children: [
                              Text("Priority:  ",style: TextStyle(color: AppColor.appDarkBlue,fontSize: 18),),
                              Expanded(
                                child: Autocomplete<String>(
                                  optionsBuilder: (TextEditingValue textEditingValue) {
                                    return ['Low', 'Medium', 'High'].where((String option) {
                                      return option.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase(),
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
                                      TextEditingController textEditingController,
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
                                        hintText: 'Select priority',
                                        hintStyle: TextStyle(fontSize: 16),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.lightBlueAccent), // Normal border color
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: AppColor.appDarkBlue), // Focus color
                                        ),
                                      ),
                                    );
                                  },
                                  optionsViewBuilder: (
                                      BuildContext context,
                                      AutocompleteOnSelected<String> onSelected,
                                      Iterable<String> options,
                                      ) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        elevation: 4.0,
                                        child: Container(
                                          constraints: BoxConstraints(maxHeight: 200),
                                          width: MediaQuery.of(context).size.width*0.15,
                                          child: ListView(
                                            children: options
                                                .map((String option) => ListTile(
                                              title: Text(option),
                                              onTap: () {
                                                onSelected(option);
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

                    ],
                  ),



                  TextButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text(
                      dueDate.isEmpty ? 'Select Due Date' : 'Due Date: $dueDate',
                    ),
                  ),

                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return ['Source A', 'Source B', 'Source C'].where((String option) {
                        return option.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
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
                        TextEditingController textEditingController,
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
                          labelText: 'Source From',
                          hintText: 'Search source from',
                        ),
                      );
                    },
                    optionsViewBuilder: (
                        BuildContext context,
                        AutocompleteOnSelected<String> onSelected,
                        Iterable<String> options,
                        ) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: Container(
                            constraints: BoxConstraints(maxHeight: 200),
                            width: MediaQuery.of(context).size.width,
                            child: ListView(
                              children: options
                                  .map((String option) => ListTile(
                                title: Text(option),
                                onTap: () {
                                  onSelected(option);
                                },
                              ))
                                  .toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  MultiSelectFormField(
                    autovalidate: AutovalidateMode.always,
                    title: Text('Assign To'),
                    dataSource: [
                      {
                        "display": "Assign A",
                        "value": "Assign A",
                      },
                      {
                        "display": "Assign B",
                        "value": "Assign B",
                      },
                      {
                        "display": "Assign C",
                        "value": "Assign C",
                      },
                      // Add other items as needed
                    ],
                    textField: 'display',
                    valueField: 'value',
                    okButtonLabel: 'OK',
                    cancelButtonLabel: 'CANCEL',
                    initialValue: selectedAssignTo,
                    onSaved: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedAssignTo = value.cast<String>(); // Ensure the value is a list of strings
                      });
                    },
                  ),



                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return categoryNames.where((String option) {
                        return option.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        );
                      });
                    },
                    onSelected: (String value) {
                      setState(() {
                        categoryName = value;
                        selectedIndex = categoryNames.indexOf(value);
                        category = selectedIndex.toString(); // Convert selectedIndex to string
                      });
                    },
                    fieldViewBuilder: (
                        BuildContext context,
                        TextEditingController textEditingController,
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
                          labelText: 'Category',
                          hintText: 'Select Category',
                        ),
                      );
                    },
                    optionsViewBuilder: (
                        BuildContext context,
                        AutocompleteOnSelected<String> onSelected,
                        Iterable<String> options,
                        ) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: Container(
                            constraints: BoxConstraints(maxHeight: 200),
                            width: MediaQuery.of(context).size.width,
                            child: ListView(
                              children: options
                                  .map((String option) => ListTile(
                                title: Text(option),
                                onTap: () {
                                  onSelected(option);
                                },
                              ))
                                  .toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  ElevatedButton(
                    onPressed: () {
                      createMainTask();
                      print('Title:${titleController.text}');
                      print('Description:${descriptionController.text}');
                      print('Selected Priority:${priority}');
                      print('Selected Due Date:${dueDate}');
                      print('Selected Source From:${sourceFrom}');
                      print('Selected Assign To:${selectedAssignTo}');
                      print('Selected Beneficiary:${beneficiary}');
                      print('Selected Category Name:${categoryName}');
                      print('Selected Category:${category}');
                    },
                    child: Text('Create Task'),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 1,
              child: Column())
        ],
      ),
    );
  }
}
