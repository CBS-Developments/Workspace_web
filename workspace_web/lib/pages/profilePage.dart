import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



import '../colors.dart';
import '../pages/loginPage.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";
  String email = "";
  String password_ = "";
  String employee_ID = "";
  String designation = "";
  String company = "";

  @override
  void initState() {
    super.initState();
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
      email = prefs.getString('email') ?? "";
      password_ = prefs.getString('password_') ?? "";
      employee_ID = prefs.getString('employee_ID') ?? "";
      designation = prefs.getString('designation') ?? "";
      company = prefs.getString('company') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Positioned(
          top: 50, // Adjust this value to change the vertical position
          right: 5, // Adjust this value to change the horizontal position
          child: AlertDialog(
            content: SizedBox(
              height: 380,
              width: 350,
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_circle_sharp, size: 120,)
                    ],
                  ),
                  Text(
                    'ID: $employee_ID',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "$firstName $lastName",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        designation,
                        style:  TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 2.0),
                        child: Icon(Icons.phone,size: 16,),
                      ),
                      Text(
                        'Tel: ',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '0$phone',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 3.0),
                        child: Icon(Icons.email_outlined,size: 16,),
                      ),
                      Text(
                        'Email: ',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '$email',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Row(
                    children: [
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 3.0),
                        child: Icon(Icons.maps_home_work_outlined,size: 16,),
                      ),
                      Text(
                        'Company: ',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        company,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: 180,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            // createUser(context);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => const ResetPasswordOne()),
                            // );

                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColor.appGrey,
                            backgroundColor: Colors.blueGrey.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5), // Rounded corners
                            ),
                          ),
                          child: const
                          Text('Reset Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),


                      ),

                      Container(
                        height: 40,
                        width: 140,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          onPressed: () async {

                            final prefs = await SharedPreferences.getInstance();
                            prefs.remove("login_state"); // Remove the "login_state" key
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const LoginPage();
                              }),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColor.appGrey,
                            backgroundColor: Colors.blueGrey.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5), // Rounded corners
                            ),
                          ),
                          child: const
                          Text('Logout',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,color: Colors.redAccent
                            ),
                          ),
                        ),


                      ),


                    ],
                  ),

                ],
              ),
            ),


          ),
        ),
      ],
    );
  }
}
