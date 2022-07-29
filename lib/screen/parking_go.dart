import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ParkingGoUI extends StatefulWidget {

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
  String carCtotal;

  ParkingGoUI(
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
  this.carCtotal
  );

  @override
  State<ParkingGoUI> createState() => _ParkingGoUIState();
}

class _ParkingGoUIState extends State<ParkingGoUI> {
  final auth = FirebaseAuth.instance;
  final CollectionReference collectionRef =
  FirebaseFirestore.instance.collection("Parking_Create");
  File? _Image;

  _openOnGoogleMapApp(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      // Could not open the map.
    }
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
        title: Text('FcPark - '+'${widget.parkingName}',style: TextStyle(
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
                        Text('${widget.carCtotal}'+'/${widget.carTotal} คัน',
                          style: TextStyle(
                            fontSize: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 90),
                    child: Container(
                      width: w * 0.75,
                      height: 55.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          primary: Color(0xFF4FCC80),
                        ),
                        onPressed: (){
                          _openOnGoogleMapApp(widget.latitude, widget.longitude);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ไปยังสถานที่จอดรถ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(width: 15,),
                            Icon(Icons.near_me,size: 30,),
                          ],
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
