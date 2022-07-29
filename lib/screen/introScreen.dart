import 'package:flutter/material.dart';
import 'package:flutter_app_fcpark/screen/all_parking.dart';
import 'package:flutter_app_fcpark/screen/home.dart';
import 'package:flutter_app_fcpark/screen/loginScreen.dart';
import 'package:flutter_app_fcpark/screen/register.dart';



class introScreenui extends StatefulWidget {
  const introScreenui({Key? key}) : super(key: key);

  @override
  State<introScreenui> createState() => _introScreenuiState();
}

class _introScreenuiState extends State<introScreenui> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 70.0,
            ),
            Image.asset("assets/images/logo.png"),
            SizedBox(
              height: 30.0,
            ),
            Image.asset("assets/images/โลโก้.png"),

            SizedBox(
              height: 80.0,
            ),
            Container(
              width: 320.0,
              height: 50.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context){
                      return RegisterUI();
                    }
                    ),
                  );
                },
                color: Color(0xFF4FCC80),
                child: Text(
                  'สมัครสมาชิก',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: 320.0,
              height: 50.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context){
                      return loginScreenUI();
                    }
                    ),
                  );
                },
                color: Color(0xFF36B1F7),
                child: Text(
                  'เข้าสู่ระบบ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}