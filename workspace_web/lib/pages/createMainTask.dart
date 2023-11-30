import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../colors.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class CreateMainTask extends StatefulWidget {
  const CreateMainTask({Key? key}) : super(key: key);

  @override
  _CreateMainTaskState createState() => _CreateMainTaskState();
}

class _CreateMainTaskState extends State<CreateMainTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String priority = 'Low';
  String dueDate = '';
  String sourceFrom = 'Source A'; // Set a default value that exists in the dropdown items
  String assignTo = 'Assign A'; // Default value from the items list
  String beneficiary = ''; // Default value from the items list
  String categoryName = ''; // Default value from the items list
  String category = 'Category Value A'; // Default value from the items list
  List<String> categoryNames = [
    'Taxation - TAS',
    'Talent Management - TMS',
    'Finance & Accounting - AFSS',
    'Audit & Assurance - ASS',
    'Company Secretarial - CSS',
    'Development - DEV'
    // Add your category items here
  ];
  int selectedIndex = -1; // Default index value // Default index value

  List<String> selectedAssignTo = [];

  List<String> beneficiaries = [
    'Beneficiary A',
    'Beneficiary B',
    'Beneficiary C',
    'Beneficiary D',
    'Beneficiary E',
    'Beneficiary F',
  ];

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
      setState(() {
        dueDate = picked.toString(); // Format the date as needed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Text('Create Main Task'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter task title',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter task description',
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: priority,
              onChanged: (newValue) {
                setState(() {
                  priority = newValue!;
                });
              },
              items: <String>['Low', 'Medium', 'High']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Priority',
                hintText: 'Select priority',
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                _selectDate(context);
              },
              child: Text(
                dueDate.isEmpty ? 'Select Due Date' : 'Due Date: $dueDate',
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: sourceFrom,
              onChanged: (newValue) {
                setState(() {
                  sourceFrom = newValue!;
                });
              },
              items: <String>['Source A', 'Source B', 'Source C']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Source From',
                hintText: 'Select source from',
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              hint: Text('Select source from'),
              value: sourceFrom,
              onChanged: (newValue) {
                setState(() {
                  sourceFrom = newValue!;
                });
              },
              items: <String>['Source A', 'Source B', 'Source C']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Source From',
                hintText: 'Select source from',
              ),
            ),
            SizedBox(height: 20),
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
                  selectedAssignTo = value;
                });
              },
            ),
            SizedBox(height: 20),
            Autocomplete<String>(
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
                    labelText: 'Beneficiary',
                    hintText: 'Search beneficiary',
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
            SizedBox(height: 20),
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

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                createMainTask();
                print('Selected Priority:${priority}');
                print('Selected Due Date:${dueDate}');
                print('Selected Source From:${sourceFrom}');
                print('Selected Assign To:${assignTo}');
                print('Selected Beneficiary:${beneficiary}');
                print('Selected Category Name:${categoryName}');
                print('Selected Category:${category}');
              },
              child: Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}
