import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fcpark/screen/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import '../server/api_insertdel.dart';


class EditProfileUI extends StatefulWidget {

  String id;
  String Image;
  String? Name;
  String? Username;
  String? Email;
  String? Password;
  String? Confirm_password;
  String? Phone_number;

  EditProfileUI(
      this.id,
      this.Image,
      this.Name,
      this.Username,
      this.Email,
      this.Password,
      this.Confirm_password,
      this.Phone_number,
      );
  @override
  State<EditProfileUI> createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
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

  TextEditingController Email = TextEditingController(text: '');
  TextEditingController Name = TextEditingController(text: '');
  TextEditingController Username = TextEditingController(text: '');
  TextEditingController Password = TextEditingController(text: '');
  TextEditingController Confirm_password = TextEditingController(text: '');
  TextEditingController Phone_number = TextEditingController(text: '');

  updateRegister() async{

    if(_Image != null){
      String imageName = Path.basename(_Image!.path);

      //อัปโหลดรุปไปที่ storage ที่ firebase
      Reference ref =  FirebaseStorage.instance.ref().child('Picture_location_tb/' + imageName);
      UploadTask uploadTask = ref.putFile(_Image!);
      //เมื่ออัปโหลดรูปเสร็จเราจะได้ที่อยู่ของรูป แล้วเราก็จะส่งที่อยู่อยู่ของรูปไปพร้อมกับข้อมูลอื่นๆ ไปเก็บที่ Firestore Database ของ Firebase
      uploadTask.whenComplete(() async {
        String imageUrl = await ref.getDownloadURL();
        bool resultInsertLocation = await apiUpdateTimeline(
            widget.id,
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
          ShowResultUpdateDialog("บันทึกเรียบร้อยเเล้ว");
        }
        else
        {
          ShowResultUpdateDialog("พบปัญหาในการทำงานกรุณาลองใหม่อีกครั้ง");
        }
      });
    }else{
      bool resultInsertLocation = await apiUpdateTimeline(
          widget.id,
          widget.Image,
          Name.text.trim(),
          Email.text.trim(),
          Username.text.trim(),
          Password.text.trim(),
          Confirm_password.text.trim(),
          Phone_number.text.trim()

      );
      if(resultInsertLocation == true)
      {
        ShowResultUpdateDialog("บันทึกเรียบร้อยเเล้ว");
      }
      else
      {
        ShowResultUpdateDialog("พบปัญหาในการทำงานกรุณาลองใหม่อีกครั้ง");
      }
    }


  }
  ShowResultUpdateDialog(String msg) async {
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
                              return HomeUI();
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

  showConfirmUpdateDialog() async {
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
                          updateRegister();
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

  @override
  void initState() {
    Email.text = widget.Email!;
    Name.text = widget.Name!;
    Username.text = widget.Username!;
    Password.text = widget.Password!;
    Confirm_password.text = widget.Confirm_password!;
    Phone_number.text = widget.Phone_number!;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    String email = FirebaseAuth.instance.currentUser!.email!;
    final Stream<QuerySnapshot> _userStrem = FirebaseFirestore.instance
        .collection("register")
        .where('Email', isEqualTo: email)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 75,
        title: Text('แก้ไขข้อมูลส่วนตัว',style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),iconSize: 20,
          onPressed: (){
            Navigator.pop(context,
              MaterialPageRoute(
                  builder: (context){
                    return HomeUI();
                  }
              ),
            );
          },
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _userStrem,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Center(
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
                          data['Image'],
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),

                    ),
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  Container(
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
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 5.0,
                    ),
                    child: TextField(
                      enabled: false,
                      controller: Email,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff51CD80))
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff000000))
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold
                        ),

                        hintText: "Input your email",
                        hintStyle: TextStyle(
                          color: Colors.grey[350],
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 5.0,
                    ),
                    child: TextField(
                      controller: Name,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff51CD80))
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff000000))
                        ),
                        labelText: "Your Name",
                        labelStyle: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold
                        ),

                        hintText: "Input your name",
                        hintStyle: TextStyle(
                          color: Colors.grey[350],
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.edit,color: Colors.black,),

                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 5.0,
                    ),
                    child: TextField(
                      controller: Username,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff51CD80))
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff000000))
                        ),
                        labelText: "Username",
                        labelStyle: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold
                        ),

                        hintText: "Input your Username",
                        hintStyle: TextStyle(
                          color: Colors.grey[350],
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.edit,color: Colors.black,),

                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 5.0,
                    ),
                    child: TextField(
                      controller: Phone_number,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff51CD80))
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff000000))
                        ),
                        labelText: "Phone number",
                        labelStyle: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold
                        ),

                        hintText: "Input your phone number",
                        hintStyle: TextStyle(
                          color: Colors.grey[350],
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.edit,color: Colors.black,),

                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: w * 0.7,
                    height: 50.0,
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
                        }else {
                          showConfirmUpdateDialog();
                        }
                      },
                      color: Color(0xFF4FCC80),
                      child: Text(
                        'บันทึกการแก้ไข',
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
            );
            }).toList()
            );
          }
      )
    );
  }
}

// Padding(
//   padding: const EdgeInsets.symmetric(
//     horizontal: 40.0,
//     vertical: 5.0,
//   ),
//   child: TextField(
//     //controller: nameCtrl,
//     decoration: InputDecoration(
//       focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Color(0xff51CD80))
//       ),
//       enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Color(0xff000000))
//       ),
//       labelText: "Password",
//       labelStyle: TextStyle(
//           color: Colors.grey[500],
//           fontWeight: FontWeight.bold
//       ),
//
//       hintText: "Input your password",
//       hintStyle: TextStyle(
//         color: Colors.grey[350],
//       ),
//       floatingLabelBehavior: FloatingLabelBehavior.always,
//       suffixIcon: Icon(Icons.edit,color: Colors.black,),
//
//     ),
//     keyboardType: TextInputType.text,
//   ),
// ),
// Padding(
//   padding: const EdgeInsets.symmetric(
//     horizontal: 40.0,
//     vertical: 5.0,
//   ),
//   child: TextField(
//     //controller: nameCtrl,
//     decoration: InputDecoration(
//       focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Color(0xff51CD80))
//       ),
//       enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Color(0xff000000))
//       ),
//       labelText: "Confirm Password",
//       labelStyle: TextStyle(
//           color: Colors.grey[500],
//           fontWeight: FontWeight.bold
//       ),
//
//       hintText: "Confirm your password",
//       hintStyle: TextStyle(
//         color: Colors.grey[350],
//       ),
//       floatingLabelBehavior: FloatingLabelBehavior.always,
//       suffixIcon: Icon(Icons.edit,color: Colors.black,),
//
//     ),
//     keyboardType: TextInputType.text,
//   ),
// ),
