import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../colors.dart';


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
  String categoryName = 'Category A'; // Default value from the items list
  String category = 'Category Value A'; // Default value from the items list
  List<String> categoryNames = ['Category A', 'Category B', 'Category C'];
  int selectedIndex = -1; // Default index value // Default index value


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
              value: assignTo,
              onChanged: (newValue) {
                setState(() {
                  assignTo = newValue!;
                });
              },
              items: <String>['Assign A', 'Assign B', 'Assign C']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Assign To',
                hintText: 'Select assign to',
              ),
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
            DropdownButtonFormField<String>(
              value: categoryNames[selectedIndex != -1 ? selectedIndex : 0], // Initial value based on selectedIndex
              onChanged: (newValue) {
                setState(() {
                  categoryName = newValue!;
                  selectedIndex = categoryNames.indexOf(newValue);
                  category = selectedIndex.toString(); // Convert selectedIndex to string
                });
              },
              items: categoryNames
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Category Name',
                hintText: 'Select category name',
              ),
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
