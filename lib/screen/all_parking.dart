import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fcpark/screen/home.dart';
import 'package:flutter_app_fcpark/screen/parking_go.dart';

class AllParkingUI extends StatefulWidget {
  const AllParkingUI({Key? key}) : super(key: key);

  @override
  State<AllParkingUI> createState() => _AllParkingUIState();
}

class _AllParkingUIState extends State<AllParkingUI> {
  final auth = FirebaseAuth.instance;
  final CollectionReference collectionRef =
  FirebaseFirestore.instance.collection("Parking_Create");

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
        title: Text('ค้นหาลานจอดรถ',style: TextStyle(
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
      body: SizedBox(
        width: w,
        height: h,
        child: Column(
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Color(0xff888888),
                  width: w * 0.3,
                  height: 1.7,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'ที่จอดรถทั้งหมด',
                    style: TextStyle(
                        color: Color(0xff888888),
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  color: Color(0xff888888),
                  width: w * 0.3,
                  height: 1.7,
                ),
              ],
            ),
            SingleChildScrollView(
              child: SizedBox(
                //color: Colors.deepOrange,
                width: w,
                height: h * 0.841,
                child: StreamBuilder(
                  stream: _userStrem,
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
                    return ListView.separated(
                      // ignore: missing_return
                      separatorBuilder: (context, index){
                        return Container(
                          height: 2,
                          width: double.infinity,
                          color: Colors.transparent,
                        );
                      },
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.only(top: 17),
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
                                          width: w * 0.82,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(height: 6,),
                                        Text("FcPark - ${(snapshot.data! as QuerySnapshot).docs[index]['parkingName']}",
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
                        );
                      },
                      itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
