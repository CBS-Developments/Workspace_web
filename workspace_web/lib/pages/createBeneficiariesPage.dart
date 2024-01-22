import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../colors.dart';
import '../componants.dart';
import '../sizes.dart';
import 'beneficiariesPage.dart';

class CreateBeneficiariesPage extends StatefulWidget {
  const CreateBeneficiariesPage({super.key});

  @override
  State<CreateBeneficiariesPage> createState() =>
      _CreateBeneficiariesPageState();
}

class _CreateBeneficiariesPageState extends State<CreateBeneficiariesPage> {

  TextEditingController fullNameController = TextEditingController();
  TextEditingController initialNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController registrationNoController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController whatsappNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController residentCountryController = TextEditingController();
  TextEditingController fixedLineController = TextEditingController();
  TextEditingController countryCitizenController = TextEditingController();
  TextEditingController contactPersonNameController = TextEditingController();
  TextEditingController contactPersonMobileController = TextEditingController();
  TextEditingController contactPersonWhatsappController = TextEditingController();
  TextEditingController servicesCategoryController = TextEditingController();

  List<String> entityTypes = [
    'Company',
    'Partnership',
    'Individual',
    'Association',

    // Add more titles as needed
  ];

  String entityType = '';



  Future<void> createBeneficiaries(BuildContext context) async {
    // Validate input fields
    if (fullNameController.text.trim().isEmpty ) {
      // Show an error message if any of the required fields are empty
      snackBar(context, "Please fill in all required fields", Colors.red);
      return;
    }

    // Other validation logic can be added here

    // If all validations pass, proceed with the registration
    var url = "http://dev.workspace.cbs.lk/createBeneficiaries.php";

    var data = {
      "cin_no": '0',
      "beneficiary_full_name": fullNameController.text.toString().trim(),
      "name_with_initial": initialNameController.text.toString().trim(),
      "short_key": '0',
      "entity_type": entityType,
      "registration_no": registrationNoController.text.toString().trim(),
      "email": emailController.text.toString().trim(),
      "fixed_line": fixedLineController.text.toString().trim(),
      "mobile": mobileController.text.toString().trim(),
      "whatsapp_No": whatsappNoController.text.toString().trim(),
      "address_": addressController.text.toString().trim(),
      "resident_country": residentCountryController.text.toString().trim(),
      "country_citizen": countryCitizenController.text.toString().trim(),
      "contact_person_name": contactPersonNameController.text.toString().trim(),
      "designation": designationController.text.toString().trim(),
      "contact_person_mobile": contactPersonMobileController.text.toString().trim(),
      "contact_person_Wh": contactPersonWhatsappController.text.toString().trim(),
      "contact_person_email": emailController.text.toString().trim(),
      "services_category": servicesCategoryController.text.toString().trim(),
      "activate": '1',
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

    if (res.statusCode.toString() == "200") {
      if (jsonDecode(res.body) == "true") {
        if (!mounted) return;
        showSuccessSnackBar(context); // Show the success SnackBar
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BeneficiariesPage()),
        );
      } else {
        if (!mounted) return;
        snackBar(context, "Error 01", Colors.yellowAccent);
      }
    } else {
      if (!mounted) return;
      snackBar(context, "Error", Colors.redAccent);
    }
  }

  void showSuccessSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content:
      Text('Create Beneficiary successful!'),
      backgroundColor: Colors.blueAccent, // You can customize the color
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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

          Expanded(
            flex: 4,
            child: SizedBox(
              height: getPageHeight(context),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey, // Shadow color
                            blurRadius: 5, // Spread radius
                            offset:
                            Offset(0, 3), // Offset in x and y directions
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: fullNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Beneficiary Full Name:',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: '',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 8,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: initialNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Name with Initial (for Individual)',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: '',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),



                          Row(
                            children: [

                              Expanded(
                                flex: 10,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: registrationNoController,
                                    decoration: InputDecoration(
                                      labelText: 'Registration No / NIC / Passport : ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: '',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 10,
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Autocomplete<String>(
                                          optionsBuilder: (TextEditingValue textEditingValue) {
                                            return entityTypes.where((String option) {
                                              return option.toLowerCase().contains(
                                                textEditingValue.text.toLowerCase(),
                                              );
                                            });
                                          },
                                          onSelected: (String value) {
                                            setState(() {
                                              entityType = value;
                                            });
                                          },
                                          fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                                            return TextField(
                                              controller: textEditingController,
                                              focusNode: focusNode,
                                              onChanged: (String text) {
                                                // Perform search or filtering here
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'Entity Type:',
                                                hintStyle: TextStyle(fontSize: 20),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.lightBlueAccent), // Normal border color
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: AppColor.appDarkBlue), // Focus color
                                                ),
                                              ),
                                            );
                                          },
                                          optionsViewBuilder: (
                                              BuildContext context,
                                              AutocompleteOnSelected<String> onSelected,
                                              Iterable<String> options,
                                              ) {
                                            return Align(
                                              alignment: Alignment.topLeft,
                                              child: Material(
                                                elevation: 4.0,
                                                child: Container(
                                                  constraints: BoxConstraints(maxHeight: 200),
                                                  width: MediaQuery.of(context).size.width*0.25,
                                                  child: ListView(
                                                    children: options
                                                        .map((String option) => ListTile(
                                                      title: Text(option),
                                                      onTap: () {
                                                        onSelected(option);
                                                      },
                                                    ))
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),

                          Row(
                            children: [

                              Expanded(
                                flex: 10,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: '',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 10,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: fixedLineController,
                                    decoration: InputDecoration(
                                      labelText: 'Fixed Line: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: '',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                          Row(
                            children: [

                              Expanded(
                                flex: 10,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: mobileController,
                                    decoration: InputDecoration(
                                      labelText: 'Mobile: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: '',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 10,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: whatsappNoController,
                                    decoration: InputDecoration(
                                      labelText: 'Whatsapp Number: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: '',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                          Row(
                            children: [

                              Expanded(
                                flex: 10,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: addressController,
                                    decoration: InputDecoration(
                                      labelText: 'Address: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: '',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 10,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: residentCountryController,
                                    decoration: InputDecoration(
                                      labelText: 'Resident Country: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: '',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                          Row(
                            children: [

                              Expanded(
                                flex: 10,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: countryCitizenController,
                                    decoration: InputDecoration(
                                      labelText: 'Country Citizen: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: '',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 10,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: servicesCategoryController,
                                    decoration: InputDecoration(
                                      labelText: 'Services Category: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: '',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                          Row(
                            children: [

                              Expanded(
                                flex: 10,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: contactPersonNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Contact Person Name (If Company): ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: '',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 10,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: designationController,
                                    decoration: InputDecoration(
                                      labelText: 'Designation: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: '',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                          Row(
                            children: [

                              Expanded(
                                flex: 10,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: contactPersonMobileController,
                                    decoration: InputDecoration(
                                      labelText: 'Mobile Number of Contact Person: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: '',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 10,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(00),
                                      color: AppColor.appGrey),
                                  child: TextField(
                                    controller: contactPersonWhatsappController,
                                    decoration: InputDecoration(
                                      labelText: 'Whatsapp Number of Contact Person: ',
                                      labelStyle: TextStyle(
                                          color: AppColor.appDarkBlue,
                                          fontSize: 20),
                                      hintText: '',
                                      hintStyle: TextStyle(fontSize: 14),
                                      // Change border and focused border colors
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .lightBlueAccent), // Normal border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor
                                                .appDarkBlue), // Focus color
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: AppColor
                                      .appDarkBlue, // Change this to the desired color
                                ),
                                onPressed: () {
                                  createBeneficiaries(context);

                                },
                                child: Text('Create Beneficiary'),
                              ),
                              SizedBox(width: 20,),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.redAccent, // Change this to the desired color
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/Beneficiaries');
                                },
                                child: Text('Cancel'),
                              ),

                              SizedBox(width: 40,),

                            ],
                          ),

                          SizedBox(height: 20,),


                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          Expanded(flex: 1, child: Column()),
        ],
      ),
    );
  }
}
