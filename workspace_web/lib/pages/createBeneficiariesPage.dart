import 'package:flutter/material.dart';

import '../colors.dart';

class CreateBeneficiariesPage extends StatefulWidget {
  const CreateBeneficiariesPage({super.key});

  @override
  State<CreateBeneficiariesPage> createState() =>
      _CreateBeneficiariesPageState();
}

class _CreateBeneficiariesPageState extends State<CreateBeneficiariesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: AppColor.appBlue,
        title: Center(child: Text('Create Beneficiaries')),
      ),
      body: Row(
        children: [
          Expanded(flex: 1, child: Column()),

          Expanded(flex: 4,
              child: Column()),

          Expanded(flex: 1, child: Column()),
        ],
      ),
    );
  }
}
