import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fcpark/screen/all_parking.dart';
import 'package:flutter_app_fcpark/screen/editProfile.dart';
import 'package:flutter_app_fcpark/screen/parking_create.dart';
import 'package:flutter_app_fcpark/screen/tabbarmaterial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'menu_bar.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({Key? key}) : super(key: key);

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
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
                        Padding(
                          padding: const EdgeInsets.only(top: 17),
                          child: Text("──────────   Nearby Parking   ──────────",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff888888),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 17, bottom: 20),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 7,
                                    borderRadius: BorderRadius.circular(25),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: InkWell(
                                      onTap: (){},
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Ink.image(image: AssetImage('assets/images/near.png'),
                                            width: w * 0.46,
                                            height: h * 0.14,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(height: 6,),
                                          Text('FcPark - ที่จอดรถข้างมหา\nวิทยาลัยเอเชียอาคเนย์',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(height: 7,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 17, bottom: 20),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 7,
                                    borderRadius: BorderRadius.circular(25),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: InkWell(
                                      onTap: (){},
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Ink.image(image: AssetImage('assets/images/free.png'),
                                            width: w * 0.46,
                                            height: h * 0.15,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(height: 6,),
                                          Text('FcPark - \n',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(height: 7,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 17, bottom: 20),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 7,
                                    borderRadius: BorderRadius.circular(25),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: InkWell(
                                      onTap: (){},
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Ink.image(image: AssetImage('assets/images/free.png'),
                                            width: w * 0.46,
                                            height: h * 0.15,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(height: 6,),
                                          Text('FcPark - \n',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(height: 7,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text("───────────   Top Parking   ───────────",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff888888),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 17, bottom: 10),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 7,
                                    borderRadius: BorderRadius.circular(25),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: InkWell(
                                      onTap: (){},
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Ink.image(image: AssetImage('assets/images/top2.jpg'),
                                            width: w * 0.46,
                                            height: h * 0.15,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(height: 6,),
                                          Text('Parking - ที่จอดรถแถว\nเยาวราช',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(height: 7,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 17,bottom: 10),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 7,
                                    borderRadius: BorderRadius.circular(25),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: InkWell(
                                      onTap: (){},
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Ink.image(image: AssetImage('assets/images/top1.png'),
                                            width: w * 0.46,
                                            height: h * 0.15,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(height: 6,),
                                          Text('Parking - ที่จอดรถสนามบิน\nสุวรรณภูมิ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(height: 7,),
                                        ],
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
                  );
                }).toList()
            );
          }
      )

    );
  }
}

