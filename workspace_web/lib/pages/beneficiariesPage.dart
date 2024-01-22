import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../colors.dart';
import '../componants.dart';

class BeneficiariesPage extends StatefulWidget {
  const BeneficiariesPage({super.key});

  @override
  State<BeneficiariesPage> createState() => _BeneficiariesPageState();
}

class _BeneficiariesPageState extends State<BeneficiariesPage> {
  List<Beneficiary> beneficiariesList = [];
  int beneficiariesCount = 0;

  @override
  void initState() {
    super.initState();
    getBeneficiaryList();
  }

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
          Center(child: Text(' $beneficiariesCount   ', style: TextStyle(fontSize: 16))),
        ],
      ),
      drawer: MyDrawer(),

      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: beneficiariesList.isNotEmpty
                ? ListView.builder(
              itemCount: beneficiariesList.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2.0),
                      margin: const EdgeInsets.all(5.0),
                      color: AppColor.appGrey,
                      child: ListTile(
                        title: Text(beneficiariesList[index].fullName),
                        subtitle: Text(beneficiariesList[index].entityType),
                        trailing: IconButton(
                          icon: Icon(Icons.edit_note_rounded, color: Colors.blueAccent.shade400),
                          onPressed: () {

                          },
                        ),
                      ),
                    ),
                    Divider()
                  ],
                );
              },
            )
                : Center(child: CircularProgressIndicator()),
          ),

          Expanded(
              flex:1,
              child: Column()),
        ],
      ),
    );
  }

  Future<void> getBeneficiaryList() async {
    beneficiariesList.clear();
    var data = {};

    const url = "http://dev.workspace.cbs.lk/getBeneficiaries.php";
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
          beneficiariesList.add(Beneficiary.fromJson(details));
        }
      });
      print("Beneficiary Count: ${beneficiariesList.length}");
      beneficiariesCount = beneficiariesList.length;
    } else {
      throw Exception('Failed to load users from API');
    }
  }

}


class Beneficiary {
  String cinNo = '';
  String fullName = '';
  String initialName = '';
  String shortKey = '';
  String entityType = '';
  String registrationNo = '';
  String email = '';
  String fixedLine = '';
  String mobile = '';
  String whatsappNo = '';
  String address = '';
  String residentCountry = '';
  String countryCitizen = '';
  String contactPersonName = '';
  String designation = '';
  String contactPersonMobile = '';
  String contactPersonWh = '';
  String contactPersonEmail = '';
  String servicesCategory = '';
  String activate = '';

  Beneficiary({
    required this.cinNo,
    required this.fullName,
    required this.initialName,
    required this.shortKey,
    required this.entityType,
    required this.registrationNo,
    required this.email,
    required this.fixedLine,
    required this.mobile,
    required this.whatsappNo,
    required this.address,
    required this.residentCountry,
    required this.countryCitizen,
    required this.contactPersonName,
    required this.designation,
    required this.contactPersonMobile,
    required this.contactPersonWh,
    required this.contactPersonEmail,
    required this.servicesCategory,
    required this.activate,
  });

  factory Beneficiary.fromJson(Map<String, dynamic> json) {
    return Beneficiary(
      cinNo: json['cin_no'],
      fullName: json['beneficiary_full_name'],
      initialName: json['name_with_initial'],
      shortKey: json['short_key'],
      entityType: json['entity_type'],
      registrationNo: json['registration_no'],
      email: json['email'],
      fixedLine: json['fixed_line'],
      mobile: json['mobile'],
      whatsappNo: json['whatsapp_No'],
      address: json['address_'],
      residentCountry: json['resident_country'],
      countryCitizen: json['country_citizen'],
      contactPersonName: json['contact_person_name'],
      designation: json['designation'],
      contactPersonMobile: json['contact_person_mobile'],
      contactPersonWh: json['contact_person_Wh'],
      contactPersonEmail: json['contact_person_email'],
      servicesCategory: json['services_category'],
      activate: json['activate'],
    );
  }
}
