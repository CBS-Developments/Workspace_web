import 'package:flutter/material.dart';

import '../colors.dart';

class CreateBeneficiariesPage extends StatefulWidget {
  const CreateBeneficiariesPage({super.key});

  @override
  State<CreateBeneficiariesPage> createState() => _CreateBeneficiariesPageState();
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
    );
  }
}
