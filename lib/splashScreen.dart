import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_fcpark/screen/introScreen.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
      Duration(seconds: 5),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => introScreenui()
              )
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [Colors.greenAccent, Color(0xff44AF6D)],
              ),
            ), //color: Colors.greenAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 75.0,
                          child: Image(
                            image: AssetImage('assets/images/fcpark_w.png'),
                            height: 200.0,
                            width: 200.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 7,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 70,)
              ],
            ),
          ),
        ],
      ),
    );

  }
}
