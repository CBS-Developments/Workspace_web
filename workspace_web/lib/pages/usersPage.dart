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
  int userCount = 0;
  User? selectedUser;

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
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/createUser');
              },
              child: Text('Create User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.appDarkBlue,
              ),
            ),
          ),
          Center(child: Text(' $userCount    ', style: TextStyle(fontSize: 16))),
        ],
      ),
      drawer: MyDrawer(),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2.0),
                      margin: const EdgeInsets.all(5.0),
                      color: AppColor.appGrey,
                      child: ListTile(
                        title: Text(
                          '${userList[index].firstName} ${userList[index].lastName}  |  ${userList[index].userName}',
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
                        onTap: () {
                          setState(() {
                            selectedUser = userList[index];
                          });
                        },
                      ),
                    ),
                    Divider()
                  ],
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: selectedUser != null ? userDetails(selectedUser!) : SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget userDetails(User user) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      margin: EdgeInsets.symmetric(horizontal: 40),
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade500,
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Details:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          Text('ID: ${user.employeeID}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Text('${user.firstName} ${user.lastName}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            user.designation,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Icon(Icons.phone,size: 16,),
              ),
              Text(
                'Tel: ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Text(
                '0${user.phone}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: Icon(Icons.email_outlined,size: 16,),
              ),
              Text(
                'Email: ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${user.email}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: Icon(Icons.maps_home_work_outlined,size: 16,),
              ),
              Text(
                'Company: ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Text(
                user.company,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
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
      userCount = userList.length;
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
