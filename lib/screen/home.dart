import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fcpark/screen/all_parking.dart';
import 'package:flutter_app_fcpark/screen/editProfile.dart';
import 'package:flutter_app_fcpark/screen/parking_create.dart';
import 'package:flutter_app_fcpark/screen/parking_go.dart';
import 'package:flutter_app_fcpark/screen/tabbarmaterial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'menu_bar.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({Key? key}) : super(key: key);

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {

  int? count;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    String email = FirebaseAuth.instance.currentUser!.email!;
    final Stream<QuerySnapshot> _userStrem = FirebaseFirestore.instance
        .collection("register")
        .where('Email', isEqualTo: email)
        .snapshots();
    final Stream<QuerySnapshot> _parking = FirebaseFirestore.instance
        .collection("Parking_Create")
        .snapshots();
    final Stream<QuerySnapshot> _topParking = FirebaseFirestore.instance
        .collection("Parking_Create")
        .where('Email', isEqualTo: 'nuttaponkoonsri@gmail.com')
        .snapshots();

    return Scaffold(
      bottomNavigationBar: TabBarMaterial(),
      drawer: MenuBar(),
      appBar: AppBar(
        leadingWidth: 75,
        title: Text('หน้าหลัก',style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        ),
        centerTitle: true,
        //leading: IconButton(
        //icon: Icon(Icons.menu),iconSize: 35,
        //onPressed: () {
        //},
        //),
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
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            padding: EdgeInsets.only(top: 15,),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: w * 0.31,
                                  height: h * 0.185,
                                  child: Card(
                                    elevation: 7.0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context){
                                            return AllParkingUI();
                                          }
                                          ),
                                        );
                                      },
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.search, size: 90.0,color: Colors.grey,),
                                            Text(
                                              'ค้นหาที่จอดรถ', style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                              color: Colors.black54,
                                            ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 5)),
                                SizedBox(
                                  width: w * 0.31,
                                  height: h * 0.185,
                                  child: Card(
                                    elevation: 7.0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context){
                                            return fcParkCreateUI();
                                          }
                                          ),
                                        );
                                      },
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.add_card,
                                              color: Colors.grey,
                                              size: 90,
                                            ),
                                            Text('สร้างลานจอดรถ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                                color: Colors.black54,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 5)),
                                SizedBox(
                                  width: w * 0.31,
                                  height: h * 0.185,
                                  child: Card(
                                    elevation: 7.0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context){
                                            return EditProfileUI(
                                              document.id,
                                              data['Image'],
                                              data['Name'],
                                              data['Username'],
                                              data['Email'],
                                              data['Password'],
                                              data['Confirm_password'],
                                              data['Phone_number'],
                                            );
                                          }
                                          ),
                                        );
                                      },
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.person,
                                              color: Colors.grey,
                                              size: 90,
                                            ),
                                            Text('ตั้งค่าผุ้ใช้ ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                                color: Colors.black54,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: Color(0xff888888),
                              width: w * 0.32,
                              height: 1.4,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'All Parking',
                                style: TextStyle(
                                    color: Color(0xff888888),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Container(
                              color: Color(0xff888888),
                              width: w * 0.32,
                              height: 1.4,
                            ),
                          ],
                        ),
                        SizedBox(height: 7,),
                        SizedBox(
                          width: w,
                          height: h * 0.3,
                          child: Padding(
                            padding: EdgeInsets.only(top: h * 0.01),
                            child: StreamBuilder(
                              stream: _parking,
                              builder: (context, snapshot){
                                if(snapshot.hasError)
                                {
                                  return const Center(
                                    child: Text('พบข้อผิดพลาดกรุณาลองใหม่อีกครั้ง'),
                                  );
                                }
                                if(snapshot.connectionState == ConnectionState.waiting)
                                {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                return GridView.builder(
                                  // ignore: missing_return
                                  itemBuilder: (context, index){
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 15, bottom: 30,),
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Material(
                                              color: Colors.white,
                                              elevation: 7,
                                              borderRadius: BorderRadius.circular(30),
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              child: InkWell(
                                                onTap: (){
                                                  Navigator.push(context,
                                                    MaterialPageRoute(builder: (context) => ParkingGoUI(
                                                        (snapshot.data! as QuerySnapshot).docs[index].id.toString(),
                                                        (snapshot.data! as QuerySnapshot).docs[index]['Email'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['Image'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['parkingName'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['name'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['phoneNumber'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['latitude'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['longitude'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['carTotal'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['status'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['carCTotal']
                                                    )
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Ink.image(
                                                      image: NetworkImage((snapshot.data! as QuerySnapshot).docs[index]['Image']),
                                                      width: w * 0.83,
                                                      height: w * 0.289,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    SizedBox(height: w * 0.015,),
                                                    Text('FcPark - '+
                                                      "${(snapshot.data! as QuerySnapshot).docs[index]['parkingName']}",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    childAspectRatio: 1 / 1,
                                    // crossAxisSpacing: 10,
                                    // mainAxisSpacing: 10
                                  ),
                                  scrollDirection: Axis.horizontal,
                                );
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: Color(0xff888888),
                              width: w * 0.31,
                              height: 1.4,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Top Parking',
                                style: TextStyle(
                                    color: Color(0xff888888),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Container(
                              color: Color(0xff888888),
                              width: w * 0.31,
                              height: 1.4,
                            ),
                          ],
                        ),
                        SizedBox(height: 7,),
                        SizedBox(
                          width: w,
                          height: h * 0.3,
                          child: Padding(
                            padding: EdgeInsets.only(top: h * 0.01),
                            child: StreamBuilder(
                              stream: _topParking,
                              builder: (context, snapshot){
                                if(snapshot.hasError)
                                {
                                  return const Center(
                                    child: Text('พบข้อผิดพลาดกรุณาลองใหม่อีกครั้ง'),
                                  );
                                }
                                if(snapshot.connectionState == ConnectionState.waiting)
                                {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if((snapshot.data! as QuerySnapshot).docs.length == 5){
                                  count = 5;
                                }else{
                                  count = (snapshot.data! as QuerySnapshot).docs.length;
                                }
                                return GridView.builder(
                                  // ignore: missing_return
                                  itemBuilder: (context, index){
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 15, bottom: 30),
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Material(
                                              color: Colors.white,
                                              elevation: 7,
                                              borderRadius: BorderRadius.circular(30),
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              child: InkWell(
                                                onTap: (){
                                                  Navigator.push(context,
                                                    MaterialPageRoute(builder: (context) => ParkingGoUI(
                                                        (snapshot.data! as QuerySnapshot).docs[index].id.toString(),
                                                        (snapshot.data! as QuerySnapshot).docs[index]['Email'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['Image'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['parkingName'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['name'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['phoneNumber'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['latitude'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['longitude'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['carTotal'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['status'],
                                                        (snapshot.data! as QuerySnapshot).docs[index]['carCTotal']
                                                    )
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Ink.image(
                                                      image: NetworkImage((snapshot.data! as QuerySnapshot).docs[index]['Image']),
                                                      width: w * 0.83,
                                                      height: w * 0.289,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    SizedBox(height: w * 0.015,),
                                                    Text('FcPark - '+
                                                        "${(snapshot.data! as QuerySnapshot).docs[index]['parkingName']}",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: count,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    childAspectRatio: 1 / 1,
                                    // crossAxisSpacing: 10,
                                    // mainAxisSpacing: 10
                                  ),
                                  scrollDirection: Axis.horizontal,
                                );
                              },
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

