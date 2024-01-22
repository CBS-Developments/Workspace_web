import 'package:flutter/material.dart';

import '../colors.dart';
import '../sizes.dart';

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

    // Add more titles as needed
  ];

  String entityType = '';

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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: AppColor
                                      .appDarkBlue, // Change this to the desired color
                                ),
                                onPressed: () {

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
