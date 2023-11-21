import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace_web/pages/taskPage.dart';
import 'package:workspace_web/sizes.dart';

import '../componants.dart';
import 'createAccountPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: getPageWidth(context),
            child: const Column(
              children: [
                SizedBox(height: 60),
                Text(
                  'Workspace',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 15),
                Divider(),
                SizedBox(height: 40),
              ],
            ),
          ),
          Container(
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom:10),
                  child: Text('Email Address: ',
                  style: TextStyle(
                    fontSize:18,
                  ),),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    //labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),

                const Padding(
                  padding: EdgeInsets.only(bottom:10),
                  child: Text('Password: ',
                    style: TextStyle(
                      fontSize:18,
                    ),),
                ),

                TextFormField(
                  controller: passwordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    //labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.only(left:2),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Forgot your password ? ",
                        style: TextStyle(fontSize: 15),
                      ),
                      TextButton(
                          onPressed: () {   },
                          child: Text(
                            'Reset It',
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: Colors.teal),
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  height: 40,
                  width: 300,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      _login();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.teal,
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(5), // Rounded corners
                      ),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "New to Workspace ?",
                      style: TextStyle(fontSize: 18),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CreateAccountPage()),
                          );
                        },
                        child: Text(
                          'Get Started',
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.teal,))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    bool success = await login(context);
    if (success) {
      // Only navigate if login is successful and the account is activated
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TaskPage()),
      );
    }
  }

  Future<bool> login(BuildContext context) async {
    if (emailController.text.trim().isEmpty) {
      snackBar(context, "Email can't be empty", Colors.redAccent);
      return false;
    }

    if (emailController.text.trim().length < 3) {
      snackBar(context, "Invalid Email.", Colors.yellow);
      return false;
    }

    var url = "http://dev.workspace.cbs.lk/login.php";
    var data = {
      "email": emailController.text.toString().trim(),
      "password_": passwordController.text.toString().trim(),
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

    if (res.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(res.body);
      print(result);
      bool status = result['status'];
      if (status) {
        if (result['activate'] == '1') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('login_state', '1');
          prefs.setString('user_name', result['user_name']);
          prefs.setString('first_name', result['first_name']);
          prefs.setString('last_name', result['last_name']);
          prefs.setString('email', result['email']);
          prefs.setString('password_', result['password_']);
          prefs.setString('phone', result['phone']);
          prefs.setString('employee_ID', result['employee_ID']);
          prefs.setString('designation', result['designation']);
          prefs.setString('company', result['company']);
          prefs.setString('user_role', result['user_role']);
          prefs.setString('activate', result['activate']);

          // Successfully logged in and account is activated
          return true;
        } else {
          snackBar(context, "Account Deactivated", Colors.redAccent);
          return false; // Account deactivated
        }
      } else {
        snackBar(context, "Incorrect Password", Colors.yellow);
        return false; // Incorrect password
      }
    } else {
      snackBar(context, "Error", Colors.redAccent);
      return false; // Error during login
    }
  }


}