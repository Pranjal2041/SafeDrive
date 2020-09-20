import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:whatthehack/insurance/data/network.dart';
import 'package:whatthehack/insurance/screens/home/homescreen.dart';
import 'package:whatthehack/user/screens/home/homescreen.dart';
import 'package:whatthehack/user/screens/profile/profilescreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isLoggingIn;

  login({role="driver"}){
    getLoginDone(role);
    setState(() {
      isLoggingIn = true;
    });
  }

  getLoginDone(role) async{
    var res = await postLogin(role);
    if(res!=null){
      if(role=="driver"){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserHomeScreen(
              ),
            ));
      }else if(role=="insurance"){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
              ),
            ));
      }
    }
    setState(() {
      isLoggingIn = false;
    });
  }

  checkButtonClick(dx,dy,width,height){
    print(width);
    print(height);
    dx = dx*360/width;
    dy = dy* 640/height;
    print(dx);
    print(dy);
    if(dx>20 && dx< 320){
      if(dy>380 && dy<415){
        login();
      }
      else if(dy>435 && dy<470){
        login(role: "insurance");
      }
    }
  }

  @override
  void initState() {
    isLoggingIn = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final width =  MediaQuery. of(context). size. width;
    final height =  MediaQuery. of(context). size. height;

    return isLoggingIn?
    // Material(
    //   child: Container(
    //     color: Colors.redAccent,
    //       child: Center(
    //         child: TextLiquidFill(
    //           text: 'Login...',
    //           loadDuration: Duration(milliseconds: 1500),
    //           waveColor: Colors.blueAccent,
    //           // boxBackgroundColor: Colors.white,
    //           boxBackgroundColor: Colors.redAccent,
    //           textStyle: TextStyle(
    //             fontSize: 80.0,
    //             fontWeight: FontWeight.bold,
    //             color: Colors.blue
    //           ),
    //           boxHeight: 300,
    //         ),
    //       ),
    //   ),
    // )
    Material(
      color: Colors.redAccent,
      child: Center(
        child: ColorizeAnimatedTextKit(
          speed: Duration(milliseconds: 500),
            onTap: () {
              print("Tap Event");
            },
            text: [
              "Login...",
            ],
            textStyle: TextStyle(
                fontSize: 80.0,
                fontFamily: "Horizon",
                fontWeight: FontWeight.bold
            ),
            colors: [
              Colors.purple,
              Colors.blue,
              Colors.yellow,
              Colors.red,
            ],
            textAlign: TextAlign.start,
            alignment: AlignmentDirectional.topStart // or Alignment.topLeft
        ),
      ),
    )
    :Container(
      child: GestureDetector(
        onTapUp: (pos) {
          print(pos.globalPosition);
          print(pos.localPosition);
          var x = pos.globalPosition.dx;
          var y = pos.globalPosition.dy;
          checkButtonClick(x, y,width,height);
        },
        child: FlareActor(
          'assets/login6.flr',
          animation: 'Untitled',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
