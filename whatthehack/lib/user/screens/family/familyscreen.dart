import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_contact/contact.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:whatthehack/insurance/screens/map_screen/widgets/marker.dart';

import 'package:whatthehack/insurance/screens/tablescreen/widgets/datatable.dart';
import 'package:whatthehack/insurance/values/colors.dart';
import 'package:whatthehack/insurance/widgets/bottom_navbar.dart';
import 'package:latlong/latlong.dart';
import 'package:whatthehack/insurance/widgets/header.dart';
import 'package:whatthehack/user/screens/family/widgets/familytable.dart';
import 'package:whatthehack/user/widgets/bottom_navbar.dart';
import 'package:intl/intl.dart';

class FamilyScreen extends StatefulWidget {
  @override
  FamilyScreenState createState() => FamilyScreenState();
}

class FamilyScreenState extends State<FamilyScreen> {
  @override
  initState() {
    super.initState();
  }

  bool formOpen = false;
  TextEditingController nameController = new TextEditingController(), contactController = new TextEditingController(), idController = new TextEditingController();
  String relation = 'friend';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  AppHeader(
                    height: 230,
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (formOpen) {
                                      setState(() {
                                        formOpen = !formOpen;
                                      });
                                    } else
                                      Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Text(
                                formOpen ? 'Add an emergency contact' : 'My Emergency contacts',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ] +
                (!formOpen
                    ? ([
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FamilyTable(),
                          ),
                        ),
                      ])
                    : [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Column(
                            children: [
                              FormBuilderTextField(
                                cursorColor: colorPalette[11],
                                controller: nameController,
                                attribute: "",
                                decoration: InputDecoration(labelText: "Name"),
                              ),
                              FormBuilderTextField(
                                cursorColor: colorPalette[11],
                                controller: contactController,
                                attribute: "",
                                decoration: InputDecoration(labelText: "Contact number"),
                              ),
                              FormBuilderTextField(
                                cursorColor: colorPalette[11],
                                controller: idController,
                                attribute: "",
                                decoration: InputDecoration(labelText: "Driver ID (optional)"),
                              ),
                              FormBuilderChoiceChip(
                                onChanged: (value) {
                                  setState(() {
                                    relation = value;
                                  });
                                },
                                attribute: "Relation",
                                decoration: InputDecoration(labelText: "Relation"),
                                options: [
                                  FormBuilderFieldOption(child: Text("Friend"), value: "friend"),
                                  FormBuilderFieldOption(child: Text("Family"), value: "family"),
                                ],
                              ),
                            ],
                          ),
                        )
                      ])),
      ),
      bottomNavigationBar: UserBottomNavbar('profile'),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: colorPalette[11],
          label: formOpen ? Text('SUBMIT') : Text('ADD CONTACTS'),
          icon: Icon(
            formOpen ? Icons.check : Icons.add,
          ),
          onPressed: () async {
            if (formOpen) familyData.add({'name': nameController.text, 'type': relation, 'contact': contactController.text, 'driverid': idController.text});
            formOpen = !formOpen;
            nameController.text = "";
            idController.text = "";
            contactController.text = "";
            setState(() {});
          }),
    );
  }
}
