import 'package:flutter/material.dart';

import '../colors.dart';
import '../sizes.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController employeeIDController = TextEditingController();

  List<String> titles = [
    'Mr.',
    'Mrs.',
    'Ms',
    'Dr.',
    'Prof.',
    'Rev.',
    // Add more titles as needed
  ];

  String title = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Center(child: Text('Create User')),
      ),
      body: Row(
        children: [
          Expanded(flex: 1, child: Column()),

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
                      margin: EdgeInsets.all(10),
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

                          Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Autocomplete<String>(
                                            optionsBuilder: (TextEditingValue textEditingValue) {
                                              return titles.where((String option) {
                                                return option.toLowerCase().contains(
                                                  textEditingValue.text.toLowerCase(),
                                                );
                                              });
                                            },
                                            onSelected: (String value) {
                                              setState(() {
                                                title = value;
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
                                                  hintText: 'Title',
                                                  hintStyle: TextStyle(fontSize: 20),
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
                                                    width: MediaQuery.of(context).size.width*0.05,
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
                                  ),),
                              Expanded(
                                flex: 8,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: firstNameController,
                                    decoration: InputDecoration(
                                      labelText: 'First Name: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: 'Enter first name',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 8,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: lastNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Last Name: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: 'Enter last name',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),



                          Row(
                            children: [

                              Expanded(
                                flex: 10,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: 'Enter email',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 8,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      labelText: 'Password: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: 'Enter password',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                          Row(
                            children: [

                              Expanded(
                                flex: 10,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: mobileNumberController,
                                    decoration: InputDecoration(
                                      labelText: 'Mobile Number: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: 'Enter mobile number',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 8,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: employeeIDController,
                                    decoration: InputDecoration(
                                      labelText: 'Employee ID: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: 'Enter employee ID',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),


                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(flex: 1, child: Column()),
        ],
      ),
    );
  }
}
