import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fcpark/screen/home.dart';

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
      body: SizedBox(
        width: w,
        height: h,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 17, bottom: 5),
              child: Text("────────────   All Parking   ────────────",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff888888),
                  fontSize: 16,
                ),
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                //color: Colors.deepOrange,
                width: w,
                height: h * 0.8245,
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
