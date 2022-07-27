import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/data.dart';

class resetpasswordUI extends StatefulWidget {
  const resetpasswordUI({Key? key}) : super(key: key);

  @override
  State<resetpasswordUI> createState() => _resetpasswordUIState();
}

class _resetpasswordUIState extends State<resetpasswordUI> {
  Data data = Data();
  final auth = FirebaseAuth.instance;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        leadingWidth: 75,
        title: Text('ลืมรหัสผ่าน',style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
    ),
    ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.greenAccent, Color(0xff51CD80)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 38.0,
                right: 38.0,
                top: 30),
            child: TextFormField(
              decoration: InputDecoration(
                fillColor: Colors.grey.shade100,
                filled: true,
                hintText: 'Enter Email',
                hintStyle: TextStyle(
                  color: Colors.black38,
                  fontSize: 18,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric
                    (horizontal: 22.0),
                  child: Icon(
                    FontAwesomeIcons.user,
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
                top: 30
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
                      onPressed: () {
                          auth.sendPasswordResetEmail(email: data.email!);
                          Navigator.of(context).pop();
                      },
                      color: Color(0xFF4FCC80),
                      child: Text(
                        'ตกลง',
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

                  ),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }
}
