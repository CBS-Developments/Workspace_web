import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace_web/pages/profilePage.dart';

Future<void> snackBar( BuildContext context, String message, Color color) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: TextStyle(color: color, fontSize: 17.0),
    ),
  ));
}



class MyAppBar extends StatefulWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {


  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";

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

    });
  }


  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: const Text(
        'CBS Workspace',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      actions: [

        Column(
          children: [
            const Text('',style: TextStyle(
              color: Colors.black,
            ),),
            Text(
              "$firstName $lastName",
              style: const TextStyle(color: Colors.black, fontSize: 18.0),
            ),
          ],
        ),

        const SizedBox(width: 10,),

        IconButton(
            onPressed: ()
            {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const ProfilePage();
                },
              );
            },
            icon: const Icon(
              Icons.account_circle_sharp,
              color: Colors.black,
            )),


        // IconButton(
        //     onPressed: ()
        //     {
        //       showPopupMenu(context);
        //     },
        //     icon: const Icon(
        //       Icons.arrow_drop_down,
        //       color: Colors.black,
        //     )),

      ],
    );
  }
}
