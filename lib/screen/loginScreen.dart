import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_fcpark/models/data.dart';
import 'package:flutter_app_fcpark/screen/home.dart';
import 'package:flutter_app_fcpark/screen/register.dart';
import 'package:flutter_app_fcpark/screen/resetpass.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class loginScreenUI extends StatefulWidget {
  @override
  State<loginScreenUI> createState() => _loginScreenUIState();
}

class _loginScreenUIState extends State<loginScreenUI> {
  TextEditingController userController = TextEditingController();

  TextEditingController passController = TextEditingController();

  Data data = Data();

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  bool showVisible = true;

  _dismisskeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  showWarningDialog(String msg) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Container(
              width: double.infinity,
              color: Color(0xFFEC4646),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Text(
                  'คำเตือน',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                msg,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                  left: 32.0,
                  right: 32.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: Text(
                          'ตกลง',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool cwarrow=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/screens.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 45, top: 65),
                      child: Text('เข้าสู่ระบบ', style: TextStyle(
                        color: Colors.green,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),

                      ),

                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 45, top: 120),
                      child: Text('dont have an account?', style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),

                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 70, top: 160),
                      child: Image.asset("assets/images/logo3.png"),

                    ),
                    Container(
                      padding: EdgeInsets.only(left: 200, top: 105),
                      child: TextButton(
                          onPressed: (){
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context){
                                return RegisterUI();
                              }
                              ),
                            );
                          },
                          child: Text(
                            '  Create your account',
                            style: TextStyle(
                              color: Colors.pinkAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 38.0,
                          right: 38.0,
                          top: 365),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'ป้อนอีเมล์',
                          hintStyle: TextStyle(
                            color: Colors.black38,
                            fontSize: 18,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric
                              (horizontal: 22.0),
                            child: Icon(
                              FontAwesomeIcons.envelope,
                              size: 24,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                          ),
                        ),
                        onChanged: (user){
                          data.email = user;
                        },
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 38.0,
                          right: 38.0,
                          top: 440),
                      child: TextFormField(
                        obscureText: !cwarrow,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'ป้อนรหัสผ่าน',
                          hintStyle: TextStyle(
                            color: Colors.black38,
                            fontSize: 18,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric
                              (horizontal: 22.0),
                            child: Icon(
                              FontAwesomeIcons.lock,
                              size: 24,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                cwarrow = !cwarrow;
                              });
                            },
                            icon: Icon(
                              cwarrow ? Icons.visibility : Icons.visibility_off,

                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                          ),
                        ),
                        onChanged: (password){
                          data.password = password;
                        },
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 255, top: 502),
                      child: TextButton(
                          onPressed: (){
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context){
                                return resetpasswordUI();
                              }
                              ),
                            );
                          },
                          child: Text(
                            'ลืมรหัสผ่าน?',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          top: 590
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              width: 350.0,
                              height: 50.0,
                              child: RaisedButton(
                                elevation: 10,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                onPressed: () async{
                                 // if(userController.text.trim().length == 0 && passController.text.trim().length == 0){
                                 //   showWarningDialog('กรุณากรอกอีเมล์หรือรหัสผ่านด้วย');
                                 // }else{
                                   try{
                                      await FirebaseAuth.instance.signInWithEmailAndPassword(email: data.email!,
                                          password: data.password!).then((value){
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomeUI()
                                            )
                                        );
                                      });
                                   }on FirebaseAuthException catch(g){
                                      String message;
                                      if(g.code == 'wrong-password'){
                                        message = 'รหัสผ่านไม่ถูกต้อง!\nกรุณาลองใหม่อีกครั้ง';
                                      }else{
                                        message = 'เกิดข้อผิดพลาด!\nกรุณาเช็ค email หริอ password ใหม่อีกครั้ง';
                                      }
                                        Fluttertoast.showToast(msg: message,
                                        gravity: ToastGravity.CENTER
                                      );
                                   }
                                 // }

                                },
                                color: Color(0xFF4FCC80),
                                child: Text(
                                  'เข้าสู่ระบบ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold
                                  ),

                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(

                              width: 350.0,
                              height: 50.0,
                              child: RaisedButton(
                                elevation: 10,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                onPressed: (){
                                  // Navigator.push(context,
                                  //   MaterialPageRoute(builder: (context){
                                  //     return HomeUI();
                                  //   }
                                  //   ),
                                  // );

                                },
                                color: Colors.redAccent,
                                child: Text(
                                  'ข้าม',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}