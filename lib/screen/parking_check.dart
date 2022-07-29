import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fcpark/models/data_park.dart';
import 'package:flutter_app_fcpark/screen/parking_list.dart';
import 'package:flutter_app_fcpark/server/api_insertdel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as Path;

import '../models/data.dart';

class ParkingCheckUI extends StatefulWidget {

  String id;
  String Email;
  String Image;
  String parkingName;
  String name;
  String phoneNumber;
  double latitude;
  double longitude;
  String carTotal;
  String status;
  String carCTotal;

  ParkingCheckUI(
      this.id,
      this.Email,
      this.Image,
      this.parkingName,
      this.name,
      this.phoneNumber,
      this.latitude,
      this.longitude,
      this.carTotal,
      this.status,
      this.carCTotal
      );

  @override
  State<ParkingCheckUI> createState() => _ParkingCheckUIState();
}

class _ParkingCheckUIState extends State<ParkingCheckUI> {
  final auth = FirebaseAuth.instance;
  final CollectionReference collectionRef =
  FirebaseFirestore.instance.collection("Parking_Create");
  File? _Image;
  Data_park data = Data_park();
  TextEditingController status = TextEditingController(text: '');
  TextEditingController carCTotal = TextEditingController(text: '');

  // var carInt = '';
  // var _carCtotal = int.parse(carCTotal.text);

  final Stream<QuerySnapshot> parkingCheck = FirebaseFirestore.instance
      .collection("Parking_Create")
      .where('Email', isEqualTo: FirebaseAuth.instance.currentUser!.email!)
      .snapshots();

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
                          UpdateStats();
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
                          Navigator.pop(context);
                          Navigator.pop(context,
                            MaterialPageRoute(builder: (context){
                              return ParkingList();
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
  UpdateStats() async{

    bool resultInsertLocation = await apiUpdateParking(
      widget.id,
      widget.Email,
      widget.Image,
      widget.parkingName,
      widget.name,
      widget.latitude,
      widget.longitude,
      widget.phoneNumber,
      widget.carTotal,
      widget.status,
      carCTotal.text.trim(),
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


  @override
  void initState() {
    status.text = widget.status;
    carCTotal.text = '${widget.carCTotal}';

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser!.email!;
    final Stream<QuerySnapshot> _userStrem = FirebaseFirestore.instance
        .collection("Parking_Create")
        .snapshots();

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: AppBar(
        leadingWidth: 75,
        title: Text('Fcpark - '+'${widget.parkingName}',style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),iconSize: 20,
          onPressed: (){
            Navigator.pop(context);
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                children: [
                  Container(
                    child: SizedBox(
                      width: w,
                      height: h*0.26,
                      child: _Image!= null
                          ?
                      Image.file(
                        _Image!,
                        fit: BoxFit.cover,
                      )
                          :
                      FadeInImage.assetNetwork(
                        placeholder: 'assets/images/nologo.png',
                        image: widget.Image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 20),
                        child: Text('FcPark - '+'${widget.parkingName}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 20),
                        child: Text('เจ้าของที่จอดรถ : '+'${widget.name}',
                          style: TextStyle(
                            color: Color(0xff888888),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Text('เบอร์โทรติดต่อ : '+'${widget.phoneNumber}',
                          style: TextStyle(
                            color: Color(0xff888888),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Text('สภานะ : ',
                          style: TextStyle(
                            color: Color(0xff888888),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text('${widget.status}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff5E5E5E),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.28),
                      Container(
                        width: w * 0.2,
                        height: 45.0,
                        child: RaisedButton(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          onPressed: (){
                          },
                          color: Color(0xFF4FCC80),
                          child: Text(
                            'เปิด',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                            ),

                          ),
                        ),
                      ),
                      SizedBox(width: 7),
                      Container(
                        width: w * 0.2,
                        height: 45.0,
                        child: RaisedButton(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          onPressed: (){
                          },
                          color: Colors.redAccent,
                          child: Text(
                            'ปิด',
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
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Color(0xff888888),
                        width: w * 0.27,
                        height: 1.7,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'จำนวนรถที่จอดอยู่',
                          style: TextStyle(
                              color: Color(0xff888888),
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Container(
                        color: Color(0xff888888),
                        width: w * 0.27,
                        height: 1.7,
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 99,),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: carCTotal,
                            maxLength: 2,
                            keyboardType: TextInputType.number,
                            // controller: parkingName,
                            decoration: InputDecoration(
                              hintText: '00',
                              hintStyle: TextStyle(
                                  color: Color(0xffB9B9B9),
                                  fontSize: 50
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent
                                )
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent
                                  )
                              ),
                            ),
                            style: TextStyle(
                                color: Color(0xff48AA6A),
                                fontSize: 50
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: Text('/${widget.carTotal} คัน',
                            style: TextStyle(
                              fontSize: 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Container(
                      width: w * 0.7,
                      height: 50.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          primary: Color(0xFF4FCC80),
                        ),
                        onPressed: (){
                          showConfirmUpdateDialog();
                        },
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
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(w * 0.3,470,0,0),
              child: Container(
                width: w * 0.4,
                height: h * 0.05,
                color: Color(0xffFAFAFA),
                child: Center(child:
                Text('แตะด้านบนเพื่อแก้ไข',
                    style: TextStyle(
                    color: Color(0xff949494),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
