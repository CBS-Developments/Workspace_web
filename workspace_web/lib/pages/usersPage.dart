import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../colors.dart';
import '../componants.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User> userList = [];

  @override
  void initState() {
    super.initState();
    getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Text(
          'Users',
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
            flex:1,
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    '${userList[index].firstName} ${userList[index].lastName}',
                  ),
                  subtitle: Text(userList[index].email),
                  trailing: Switch(
                    value: userList[index].activate == '1',
                    onChanged: (value) {
                      setState(() {
                        userList[index].activate = value ? '1' : '0';
                      });
                      userStatusToggle(userList[index].userName, value);
                    },
                    activeColor: Colors.green,
                    inactiveTrackColor: Colors.redAccent.withOpacity(0.5),
                  ),
                );
              },
            ),
          ),
          Expanded(flex:1,child: Column()),
        ],
      ),
    );
  }

  Future<void> getUserList() async {
    userList.clear();
    var data = {};

    const url = "http://dev.workspace.cbs.lk/userList.php";
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
          userList.add(User.fromJson(details));
        }
      });
      print("User Count: ${userList.length}");
    } else {
      throw Exception('Failed to load users from API');
    }
  }

  Future<void> userStatusToggle(String userName, bool activate) async {
    var data = {
      "user_name": userName,
      "activate": activate ? '1' : '0',
    };

    const url = "http://dev.workspace.cbs.lk/userStatus.php";
    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(res.body);
      print(result);
    }
  }
}

class User {
  String userName = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String phone = '';
  String employeeID = '';
  String designation = '';
  String company = '';
  String userRole = '';
  String activate = '';

  User({
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    required this.employeeID,
    required this.designation,
    required this.company,
    required this.userRole,
    required this.activate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['user_name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      password: json['password_'],
      phone: json['phone'],
      employeeID: json['employee_ID'],
      designation: json['designation'],
      company: json['company'],
      userRole: json['user_role'],
      activate: json['activate'],
    );
  }
}
