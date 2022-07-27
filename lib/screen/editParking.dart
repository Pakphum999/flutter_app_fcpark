import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_fcpark/screen/parking_list.dart';
import 'package:image_picker/image_picker.dart';

import 'map_regis_locate.dart';


class editParkingUI extends StatefulWidget {



  const editParkingUI({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    String lat = '';
    String long = '';

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 75,
        title: Text('แก้ไขลานจอดรถ',style: TextStyle(
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
                          height: h*0.22,
                          child: _Image != null
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
                      //controller: nameCtrl,
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
                      //controller: nameCtrl,
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
                      //controller: nameCtrl,
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
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 5.0,
                    ),
                    child: TextField(
                      //controller: nameCtrl,
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
                      keyboardType: TextInputType.text,
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
                        onPressed: () {Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapRegisUI()
                            )
                        ).then((value){
                          lat = value[0];
                          long = value[1];
                          latitude.text = value[0];
                          longitude.text = value[1];

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