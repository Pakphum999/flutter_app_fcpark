import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fcpark/screen/home.dart';
import 'package:flutter_app_fcpark/screen/parking_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import '../server/api_insertdel.dart';
import 'map_regis_locate.dart';


class editParkingUI extends StatefulWidget {

  String id;
  String Email;
  String Image;
  String? parkingName;
  String? name;
  String? phoneNumber;
  double latitude;
  double longitude;
  String? carTotal;
  String status;
  String carCTotal;

  editParkingUI(
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
  State<editParkingUI> createState() => _editParkingUIState();
}

class _editParkingUIState extends State<editParkingUI> {
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

  TextEditingController parkingName = TextEditingController(text: '');
  TextEditingController name = TextEditingController(text: '');
  TextEditingController latitude = TextEditingController(text: '');
  TextEditingController longitude = TextEditingController(text: '');
  TextEditingController phoneNumber = TextEditingController(text: '');
  TextEditingController carTotal = TextEditingController(text: '');
  double? _latitude;
  double? _longitude;

  updateParking() async{
    if(_Image != null){
      String imageName = Path.basename(_Image!.path);
      //อัปโหลดรุปไปที่ storage ที่ firebase
      Reference ref =  FirebaseStorage.instance.ref().child('Picture_location_tb/' + imageName);
      UploadTask uploadTask = ref.putFile(_Image!);
      //เมื่ออัปโหลดรูปเสร็จเราจะได้ที่อยู่ของรูป แล้วเราก็จะส่งที่อยู่อยู่ของรูปไปพร้อมกับข้อมูลอื่นๆ ไปเก็บที่ Firestore Database ของ Firebase
      uploadTask.whenComplete(() async {
        String imageUrl = await ref.getDownloadURL();
        bool resultInsertLocation = await apiUpdateParking(
            widget.id,
            widget.Email,
            imageUrl,
            parkingName.text.trim(),
            name.text.trim(),
            _latitude!,
            _longitude!,
            phoneNumber.text.trim(),
            carTotal.text.trim(),
            widget.status,
            widget.carCTotal,
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
      bool resultInsertLocation = await apiUpdateParking(
          widget.id,
          widget.Email,
          widget.Image,
          parkingName.text.trim(),
          name.text.trim(),
          _latitude!,
          _longitude!,
          phoneNumber.text.trim(),
          carTotal.text.trim(),
          widget.status,
          widget.carCTotal,
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
  deleteManu() async{
    bool result = await apiDelParking(widget.id);

    //ลบไฟล์ออกจาก Storage
    FirebaseStorage.instance.refFromURL(widget.Image).delete();

    //นำผลที่ได้จากการทำงานมาตรวจสอบเเล้วแสดง
    if(result == true){
      ShowResultDeleteDialog('ลบเมนูเรียบร้อยเเล้ว');
    }else{
      ShowResultDeleteDialog('มีปัญหาในการลบข้อมูลกรุณารองใหม่อีกครั้ง');
    }
  }

  ShowResultDeleteDialog(String msg) async {
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
                          Navigator.pop(context);
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
                  'FcPark',
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
                          updateParking();
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
        );
      },
    );
  }
  showConfirmDeleteDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xffFFFFFF),
          title: Center(
            child: Container(
              width: double.infinity,
              color: Color(0xffB80000),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Text(
                  'FcPark',
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
                'ต้องการลบข้อมูลหรือไม่ ?',
                style: TextStyle(
                    color: Color(0xffB80000),
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
                          deleteManu();
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
        );
      },
    );
  }

  @override
  void initState() {
    _latitude = widget.latitude;
    _longitude = widget.longitude;
    parkingName.text = widget.parkingName!;
    name.text = widget.name!;
    phoneNumber.text = widget.phoneNumber!;
    carTotal.text = widget.carTotal!;
    latitude.text = '$_latitude';
    longitude.text = '$_longitude';

    // TODO: implement initState
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    double lat = 0;
    double long = 0;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 75,
        title: Text('${widget.parkingName}',style: TextStyle(
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
                    return ParkingList();
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
                          height: h*0.25,
                          child: _Image != null
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
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(w * 0.85,h * 0.015,0,0),
                        child: Material(
                          child: IconButton(
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              showBottomSheetForSelectImage(context);
                            },
                            iconSize: 25.0,
                          ),
                          color: Colors.white,
                          elevation: 5,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 5.0,
                    ),
                    child: TextField(
                      controller: parkingName,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff51CD80))
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff4F4F4F))
                        ),
                        labelText: "ชื่อลานจอดรถ",
                        labelStyle: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold
                        ),

                        hintText: "Input your parking name",
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
                      controller: name,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff51CD80))
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff4F4F4F))
                        ),
                        labelText: "ชื่อเจ้าของลานจอดรถ",
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
                  SizedBox(height: 8,),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 5.0,
                    ),
                    child: TextField(
                      controller: phoneNumber,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff51CD80))
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff4F4F4F))
                        ),
                        labelText: "เบอร์โทรติดต่อ",
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
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 5.0,
                    ),
                    child: TextField(
                      maxLength: 2,
                      controller: carTotal,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff51CD80))
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff4F4F4F))
                        ),
                        labelText: "จำนวนที่จอดรถ",
                        labelStyle: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold
                        ),

                        hintText: "Input your parking space",
                        hintStyle: TextStyle(
                          color: Colors.grey[350],
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.edit,color: Colors.black,),

                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 280,top: 10),
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
                        onPressed: () {
                          latitude.text = '';
                          longitude.text = '';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapRegisUI()
                            )
                        ).then((value){
                          lat = value[0];
                          long = value[1];
                          _latitude = lat as double?;
                          _longitude = long as double?;
                          latitude.text = '$_latitude';
                          longitude.text = '$_longitude';
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
                      controller: latitude,
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
                      controller: longitude,
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
                              }else if(latitude.text.trim().length == 0) {
                                showWarningDialog('กรุณาเลือกตำแหน่งที่จอดรถด้วย');
                              }else if(longitude.text.trim().length == 0) {
                                showWarningDialog('กรุณาเลือกตำแหน่งที่จอดรถด้วย');
                              }else{
                                showConfirmUpdateDialog();
                              }
                            },
                            color: Color(0xFF4FCC80),
                            child: Text(
                              'บันทึก',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
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
                              showConfirmDeleteDialog();
                            },
                            color: Colors.redAccent,
                            child: Text(
                              'ลบที่จอดรถ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
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
          ],
        ),
      ),
    );
  }
}