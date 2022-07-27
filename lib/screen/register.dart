import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_fcpark/models/data.dart';
import 'package:flutter_app_fcpark/screen/home.dart';
import 'package:flutter_app_fcpark/screen/loginScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter_app_fcpark/server/api_insertdel.dart';

class RegisterUI extends StatefulWidget {
  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  _dismisskeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  TextEditingController Name = TextEditingController(text: '');

  TextEditingController Email = TextEditingController(text: '');

  TextEditingController Username = TextEditingController(text: '');

  TextEditingController Password = TextEditingController(text: '');

  TextEditingController Confirm_password = TextEditingController(text: '');

  TextEditingController Phone_number = TextEditingController(text: '');
  showBottomSheetForSelectImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Color(0xff51CD80),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 28.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      showSelectImageFromCamera();
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                    ),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('กล้อง',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                  ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      showSelectImageFormGallery();
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                    ),
                    icon: const Icon(Icons.camera),
                    label: const Text('แกลอรี่',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  showSelectImageFromCamera() async {
    PickedFile? imageFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );
    if (imageFile == null) return;
    setState(() {
      _Image = File(imageFile.path);
    });
  }
  showSelectImageFormGallery() async {
    PickedFile? imageFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (imageFile == null) return;
    setState(() {
      _Image = File(imageFile.path);
    });
  }
  File? _Image;

  Data data = Data();

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

  showConfirmInsertDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xffFFFFFF),
          title: Center(
            child: Container(
              width: double.infinity,
              color: Color(0xff48AA6A),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Text(
                  'ยืนยัน',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ต้องการบันทึกข้อมูลหรือไม่ ?',
                style: TextStyle(
                    color: Color(0xff277141),
                    fontWeight: FontWeight.bold
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 32.0,
                  right: 32.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          insertRegister();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: const Text(
                          'ตกลง',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: const Text(
                          'ยกเลิก',
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

  insertRegister() async{

    String imageName = Path.basename(_Image!.path);

    //อัปโหลดรุปไปที่ storage ที่ firebase
    Reference ref =  FirebaseStorage.instance.ref().child('Picture_location_tb/' + imageName);
    UploadTask uploadTask = ref.putFile(_Image!);
    //เมื่ออัปโหลดรูปเสร็จเราจะได้ที่อยู่ของรูป แล้วเราก็จะส่งที่อยู่อยู่ของรูปไปพร้อมกับข้อมูลอื่นๆ ไปเก็บที่ Firestore Database ของ Firebase
    uploadTask.whenComplete(() async{
      String imageUrl = await ref.getDownloadURL();
      try{
        FirebaseStorage.instance.ref();
        data.email = Email.text.trim();
        data.password = Password.text.trim();
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: data.email!, password: data.password!)
            .then((value) async{
          bool resultInsertLocation = await apiInsertTimeline(
              imageUrl,
              Name.text.trim(),
              Email.text.trim(),
              Username.text.trim(),
              Password.text.trim(),
              Confirm_password.text.trim(),
              Phone_number.text.trim()

          );

          if(resultInsertLocation == true)
          {
            ShowResultInsertDialog("บันทึกเรียบร้อยเเล้ว");
          }
          else
          {
            ShowResultInsertDialog("พบปัญหาในการทำงานกรุณาลองใหม่อีกครั้ง");
          }
        });
      }
      on FirebaseAuthException catch(e){
        String message;
        if(e.code == 'email-already-in-use'){
          message = 'อีเมลถูกใช้งานแล้ว กรุณาใช้อีเมลอื่น';
        }
        else{
          message = 'รหัสผ่านต้องมากกว่า 6 คัว';
        }
        Fluttertoast.showToast(msg: message, gravity: ToastGravity.CENTER);
      }
      //ทำการอัปโหลดที่อยู่ของรูปพร้อมกับข้อมูลอื่นๆ โดยจะเรียกใช้ api


    });



  }

  ShowResultInsertDialog(String msg) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xffFFFFFF),
          title: Center(
            child: Container(
              width: double.infinity,
              color: Color(0xff48AA6A),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Text(
                  'ผลการทำงาน',
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
                style: const TextStyle(
                    color: Color(0xff277141),
                    fontWeight: FontWeight.bold
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
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
                          //Navigator.of(context).popUntil((route) => route.isFirst);
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context){
                              return loginScreenUI();
                            }
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                        ),
                        child: const Text(
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
            image: AssetImage('assets/images/screens.jpg'),
            fit: BoxFit.cover,
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 45, top: 65),
                child: Text('สมัครสมาชิก', style: TextStyle(
                  color: Color(0xFF4FCC80),
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 45, top: 120),
                child: Text('alrady Have an account?', style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 225, top: 105),
                child: TextButton(
                    onPressed: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context){
                          return loginScreenUI();
                        }
                        ),
                      );
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 160),
                child: Center(
                  child: Container(

                    child: _Image != null
                        ?
                    ClipOval(
                      child: Image.file(
                        _Image!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,

                      ),
                    )
                        :
                    ClipOval(
                      child: Image.network(
                        'https://s.car.info/g/no-avatar.jpg',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 330),
                child: Center(
                  child: Container(
                    width: 190,
                    height: 45.0,
                    child: RaisedButton(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onPressed: (){
                        showBottomSheetForSelectImage(context);
                      },
                      color: Color(0xFFFFFFFF),
                      child: Text(
                        'UPLOAD A NEW PHOTO',
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),

                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 45.0,
                    right: 45.0,
                    top: 400                ),
                child: TextField(
                  controller: Name,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'ป้อนชื่อ - นามสกุล',
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
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 45.0,
                    right: 45.0,
                    top: 475
                ),
                child: TextField(
                  controller: Email,
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
                        Icons.email_outlined,
                        size: 24,
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                  ),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 45.0,
                    right: 45.0,
                    top: 550
                ),
                child: TextField(
                  controller: Username,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'ป้อนชื่อผู้ใช้',
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
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 45.0,
                    right: 45.0,
                    top: 625
                ),
                child: TextField(
                  obscureText: !cwarrow,
                  controller: Password,
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
                        Icons.vpn_key,
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
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 45.0,
                    right: 45.0,
                    top: 700
                ),
                child: TextField(
                  obscureText: !cwarrow,
                  controller: Confirm_password,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'ป้อนยืนยันรหัสผ่าน',
                    hintStyle: TextStyle(
                      color: Colors.black38,
                      fontSize: 18,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric
                        (horizontal: 22.0),
                      child: Icon(
                        Icons.vpn_key_outlined,
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
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 45.0,
                    right: 45.0,
                    top: 775
                ),
                child: TextField(
                  controller: Phone_number,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'ป้อนเบอร์โทรศัพท์',
                    hintStyle: TextStyle(
                      color: Colors.black38,
                      fontSize: 18,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric
                        (horizontal: 22.0),
                      child: Icon(
                        Icons.phone,
                        size: 24,
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                  ),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 865,
                ),
                child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: 345.0,
                          height: 55.0,
                          child: RaisedButton(
                            elevation: 10,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            onPressed: (){
                              if(Name.text.trim().length == 0){
                                showWarningDialog('กรุณากรอกชื่อของท่านด้วย');
                              }else if(Email.text.trim().length == 0) {
                                showWarningDialog('กรุณากรอกอีเมล์ของท่านด้วย');
                              }else if(Username.text.trim().length == 0) {
                                showWarningDialog('กรุณากรอก Username ของท่านด้วย');
                              }else if(Password.text.trim().length == 0) {
                                showWarningDialog('กรุณากรอกรหัสผ่านของท่านด้วย');
                              }else if(Confirm_password.text.trim().length == 0) {
                                showWarningDialog('กรุณากรอกยืนยันรหัสผ่านของท่านด้วย');
                              }else if(Phone_number.text.trim().length == 0) {
                                showWarningDialog('กรุณากรอกเบอร์โทรศัพท์ของท่านด้วย');
                              }else if(_Image == null) {
                                showWarningDialog('กรุณาเพิ่มรูปโปรไฟล์ด้วย');
                              }else {
                                showConfirmInsertDialog();
                              }
                            },
                            color: Color(0xFF4FCC80),
                            child: Text(
                              'ยืนยันการสมัครสมาชิก',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 13,),
                        Container(
                          width: 345.0,
                          height: 55.0,
                          child: RaisedButton(
                            elevation: 10,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            highlightElevation: 20.0,
                            hoverColor: Colors.white,
                            color: Colors.redAccent,
                            child: Text(
                              'ข้าม',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: (){
                              // Navigator.push(context,
                              //   MaterialPageRoute(builder: (context){
                              //     return HomeUI();
                              //   }
                              //   ),
                              // );
                            },
                          ),
                        ),
                        SizedBox(height: 40,)
                      ],
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


