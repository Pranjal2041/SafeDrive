import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:whatthehack/insurance/screens/home/homescreen.dart';

import 'package:syncfusion_flutter_core/core.dart';
import 'package:whatthehack/insurance/data/network.dart';
import 'package:whatthehack/insurance/values/colors.dart';
import 'package:whatthehack/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await GlobalConfiguration().loadFromAsset('secrets');
    SyncfusionLicense.registerLicense(
        // ignore: deprecated_member_use
        GlobalConfiguration().getString('calendar_api_key'));
  } catch (e) {
    print('secrets.json file is required');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchCompleteData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: colorPalette[11],
              accentColor: colorPalette[11],
            ),
            // home: ReportCrashResult(
            //   lat: 28.68627,
            //   long: 77.2217831,
            // ),
            home: LoginScreen(),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
