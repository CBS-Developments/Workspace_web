import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace_web/colors.dart';
import 'package:workspace_web/pages/createMainTask.dart';
import 'package:workspace_web/pages/dashboardPage.dart';
import 'package:workspace_web/pages/loginPage.dart';
import 'package:workspace_web/pages/openMainTask.dart';
import 'package:workspace_web/pages/taskLogPage.dart';
import 'package:workspace_web/pages/taskPage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColor.appTeal,
      ),
      routes: {
        '/Dashboard': (context) => Dashboard(),
        '/Task': (context) => TaskPage(),
        '/Log': (context) => TaskLogPage(),
        '/createMainTask': (context) => CreateMainTask(),
        // '/Special Notice': (context) => SpecialNoticeScreen(),
        // '/Chat': (context) => ChatScreen(),
        // '/Users': (context) => UsersScreen(),
        // '/Meet': (context) => MeetScreen(),
        // '/Apps': (context) => AppsScreen(),
      },
      home: LandingPage(prefs: prefs),
    );
  }
}

class LandingPage extends StatelessWidget {
  final SharedPreferences prefs;

  const LandingPage({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _decideMainPage();
  }

  Widget _decideMainPage() {
    if (prefs.getString('login_state') != null) {
      return const TaskPage();
    } else {
      return const LoginPage();
    }
  }
}
