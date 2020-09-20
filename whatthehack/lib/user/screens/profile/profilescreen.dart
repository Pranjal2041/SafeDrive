import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:whatthehack/insurance/screens/home/widgets/body.dart';
import 'package:whatthehack/insurance/screens/charts/filters.dart';
import 'package:whatthehack/insurance/widgets/header.dart';
import 'package:whatthehack/user/screens/family/widgets/familytable.dart';
import 'package:whatthehack/user/screens/profile/widgets/profilecard.dart';
import 'package:whatthehack/user/widgets/bottom_navbar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Future completeDataFuture = fetchCompleteData();
  @override
  void initState() {
    removeFilters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          AppHeader(
            height: 220,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: NetworkImage("https://picsum.photos/250?image=9"), fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Richard Thompson",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "Driver ID: 12341432",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "Contact: 932123432",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          ProfileCard(
            title: 'Family and Friends',
            content: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FamilyTable(),
            ),
          ),
          Container(height: 10),
          ProfileCard(
            seedetails: false,
            title: 'Driving Licence',
            content: FormBuilderImagePicker(
              attribute: "images",
            ),
          ),
          Container(height: 10),
          ProfileCard(
            seedetails: false,
            title: 'Insurance Policy',
            content: FormBuilderImagePicker(
              attribute: "images",
            ),
          ),
          SizedBox(
            height: 30,
          )
        ]),
      ),
      bottomNavigationBar: UserBottomNavbar('profile'),
    );
  }
}
