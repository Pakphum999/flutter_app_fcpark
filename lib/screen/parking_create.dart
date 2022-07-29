import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fcpark/models/data_park.dart';
import 'package:flutter_app_fcpark/screen/home.dart';
import 'package:flutter_app_fcpark/screen/map_regis_locate.dart';
import 'package:flutter_app_fcpark/screen/parking_list.dart';
import 'package:flutter_app_fcpark/server/api_insertdel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as Path;

class fcParkCreateUI extends StatefulWidget {
  const fcParkCreateUI({Key? key}) : super(key: key);

  @override
  State<fcParkCreateUI> createState() => _fcParkCreateUIState();
}

class _fcParkCreateUIState extends State<fcParkCreateUI> {

  File? _Image;

  double? latitude;
  double? longtitude;
  String carCTotal = '00';
  String status = 'เปิด';

  TextEditingController email = TextEditingController(text: '');
  TextEditingController parkingName = TextEditingController(text: '');
  TextEditingController name = TextEditingController(text: '');
  TextEditingController latitudeCtrl = TextEditingController(text: '');
  TextEditingController longtitudeCtrl = TextEditingController(text: '');
  TextEditingController phoneNumber = TextEditingController(text: '');
  TextEditingController carTotal = TextEditingController(text: '');

  Data_park data = Data_park();

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
                          insertParking();
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

  insertParking() async{

    //อัปโหลดรูปรูปไปไว้ที่ storage ของ Firebase เพราะเราต้องการตำแหน่งรูปมาใช้เพื่อเก็บใน firestore
    //ชื่อรูป
    String imageName = Path.basename(_Image!.path);
    //อัปโหลดรุปไปที่ storage ที่ firebase
    Reference ref =  FirebaseStorage.instance.ref().child('Picture_product_tb/' + imageName);
    UploadTask uploadTask = ref.putFile(_Image!);
    //เมื่ออัปโหลดรูปเสร็จเราจะได้ที่อยู่ของรูป แล้วเราก็จะส่งที่อยู่อยู่ของรูปไปพร้อมกับข้อมูลอื่นๆ ไปเก็บที่ Firestore Database ของ Firebase
    uploadTask.whenComplete(() async{
      String imageUrl = await ref.getDownloadURL();

      //ทำการอัปโหลดที่อยู่ของรูปพร้อมกับข้อมูลอื่นๆ โดยจะเรียกใช้ api
      bool resultInsertLocation = await apiInsertParking(
          email.text.trim(),
          imageUrl,
          parkingName.text.trim(),
          name.text.trim(),
          latitude!,
          longtitude!,
          phoneNumber.text.trim(),
          carTotal.text.trim(),
          status,
          carCTotal,
      );

      if(resultInsertLocation == true)
      {
        ShowResultInsertDialog("ข้อมูลถูกบันทึกแล้ว");
      }
      else
      {
        ShowResultInsertDialog("พบปัญหาในการทำงานกรุณาลองใหม่อีกครั้ง");
      }

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
                          Navigator.pop(context);
                          Navigator.pop(context);
                            // MaterialPageRoute(builder: (context){
                            //   return ParkingList();
                            // }
                            // ),
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

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    String lat = '';
    String long = '';
    email.text = FirebaseAuth.instance.currentUser!.email!;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 75,
        title: Text('สร้างลานจอดรถ',style: TextStyle(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        child: SizedBox(
                          width: w,
                          height: h*0.27,
                          child: _Image!= null
                              ?
                          Image.file(
                            _Image!,
                            fit: BoxFit.cover,
                          )
                              :
                          Image.asset(
                            'assets/images/nologo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(w * 0.84,h * 0.185,0,0),
                        child: Material(
                          child: IconButton(
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              showBottomSheetForSelectImage(context);
                            },
                            iconSize: 30.0,
                          ),
                          color: Colors.white,
                          elevation: 5,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),//กล้อง
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 38.0,
                        right: 38.0,
                        top: 20
                    ),
                    child: TextField(
                      controller: parkingName,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'ชื่อลานจอดรถ',
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
                        left: 38.0,
                        right: 38.0,
                        top: 17),
                    child: TextField(
                      controller: name,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'ชื่อเจ้าของลานจอดรถ',
                        hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 18,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric
                            (horizontal: 17.0),
                          child: Icon(
                            Icons.person,
                            size: 35,
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
                        left: 38.0,
                        right: 38.0,
                        top: 17),
                    child: TextField(
                      controller: phoneNumber,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'เบอร์โทรติดต่อ',
                        hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 18,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric
                            (horizontal: 22.0),
                          child: Icon(
                            FontAwesomeIcons.phone,
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
                        left: 38.0,
                        top: 17,
                        right: 38.0
                    ),
                    child: TextField(
                      controller: carTotal,
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'จำนวนที่จอดรถ',
                        hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 18,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric
                            (horizontal: 22.0),
                          child: Icon(
                            FontAwesomeIcons.car,
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


                  Container(
                    padding: EdgeInsets.only(
                        top: 5.0
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black38,
                          width: 1.7,
                        ),
                      ),
                    ),
                    child: Text(
                        '                                                                                                    '
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 280,top: 20),
              child: Text(
                'ที่อยู่',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffC5C5C5),

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 40,right: 40),
                child: SizedBox(
                  child: ElevatedButton(
                    onPressed: () {Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapRegisUI()
                        )
                    ).then((value){
                      latitude = value[0];
                      longtitude = value[1];
                      latitudeCtrl.text = '$latitude';
                      longtitudeCtrl.text = '$longtitude';

                    });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      primary: const Color(0xff7FBD97),
                    ),
                    child: Row(
                      children: const [
                        SizedBox(width: 3,),
                        Icon(Icons.add_location_rounded),
                        Padding(
                          padding: EdgeInsets.only(left: 23,right: 85),
                          child: Text(
                            'ตำแหน่งปัจจุบัน',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              fontSize: 17
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                  height: 50,
                  width: w,
                ),

            ),
            SizedBox(height: 7,),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 5.0,
              ),
              child: TextField(
                controller: latitudeCtrl,
                enabled: false,
                style: TextStyle(color: Color(0xff4D4D4D)),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff51CD80))
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff000000))
                  ),
                  labelText: "Latitude",
                  labelStyle: TextStyle(
                      color: Color(0xffA8A8A8),
                      fontWeight: FontWeight.bold
                  ),
                  hintText: "เลือกที่ตำแหน่งปัจจุบัน",
                  hintStyle: TextStyle(
                    color: Colors.grey[350],
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(Icons.pin_drop_outlined,color: Colors.black,),

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
                controller: longtitudeCtrl,
                enabled: false,
                style: TextStyle(color: Color(0xff4D4D4D)),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff51CD80))
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff000000))
                  ),
                  labelText: "Longitude",
                  labelStyle: TextStyle(
                      color: Color(0xffA8A8A8),
                      fontWeight: FontWeight.bold
                  ),

                  hintText: "เลือกที่ตำแหน่งปัจจุบัน",
                  hintStyle: TextStyle(
                    color: Colors.grey[350],
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(Icons.pin_drop,color: Colors.black,),

                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 25, bottom: 35,left: w * 0.09),
              child: Row(
                children: [
                  Container(
                    width: w * 0.39,
                    height: 50.0,
                    child: RaisedButton(
                      elevation: 10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      onPressed: (){
                        if(parkingName.text.trim().length == 0){
                          showWarningDialog('กรุณากรอกชื่อลานจอดรถ');
                        }else if(name.text.trim().length == 0) {
                          showWarningDialog('กรุณากรอกชื่อเจ้าของลานจอดรถ');
                        }else if(phoneNumber.text.trim().length == 0) {
                          showWarningDialog('กรุณากรอกเบอร์โทรศัพท์');
                        }else if(carTotal.text.trim().length == 0) {
                          showWarningDialog('กรุณากรอกจำนวนช่องจอดรถ');
                        }else if(_Image == null) {
                          showWarningDialog('กรุณาเพิ่มรูปสถานที่จอดรถ');
                        }else if(latitudeCtrl.text.trim().length == 0) {
                          showWarningDialog('กรุณาเลือกตำแหน่งที่จอดรถด้วย');
                        }else if(longtitudeCtrl.text.trim().length == 0) {
                          showWarningDialog('กรุณาเลือกตำแหน่งที่จอดรถด้วย');
                        }else{
                          showConfirmInsertDialog();
                        }
                      },
                      color: Color(0xFF4FCC80),
                      child: Text(
                        'บันทึก',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                        ),

                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: w * 0.39,
                    height: 50.0,
                    child: RaisedButton(
                      elevation: 10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      onPressed: (){
                      },
                      color: Colors.redAccent,
                      child: Text(
                        'ยกเลิก',
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
          ],
        ),
      ),
    );
  }
}

//Container(
//margin: const EdgeInsets.all(10.0),
//width: 350.0,
//height: 80.0,
//color: Color(0xff7FBD97),
//),
