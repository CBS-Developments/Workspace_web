import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../colors.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  String getCurrentDate() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Center(child: Text('Your Notes')),

      ),

      body: Row(
        children: [
          Expanded(flex: 1,child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your note here'
                      ),
                      maxLines: 5,
                    ),

                    Row(
                      children: [
                        Text(getCurrentDate(),)
                      ],
                    )
                  ],
                ),

              ),


            ],
          )),

          Expanded(flex: 1,child: Column()),
        ],
      ),
    );
  }
}
