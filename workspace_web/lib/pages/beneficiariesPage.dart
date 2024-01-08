import 'package:flutter/material.dart';

import '../colors.dart';
import '../componants.dart';

class BeneficiariesPage extends StatefulWidget {
  const BeneficiariesPage({super.key});

  @override
  State<BeneficiariesPage> createState() => _BeneficiariesPageState();
}

class _BeneficiariesPageState extends State<BeneficiariesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Text(
          'Beneficiaries',
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
                Navigator.pushNamed(context, '/createBeneficiaries');
              },
              child: Text('Create Beneficiaries'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.appDarkBlue,
              ),
            ),
          ),
          Center(child: Text('    ', style: TextStyle(fontSize: 16))),
        ],
      ),
      drawer: MyDrawer(),
    );
  }
}
