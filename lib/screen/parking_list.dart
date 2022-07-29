import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fcpark/screen/editParking.dart';
import 'package:flutter_app_fcpark/screen/home.dart';
import 'package:flutter_app_fcpark/screen/parking_check.dart';
import 'package:flutter_app_fcpark/screen/parking_create.dart';



class ParkingList extends StatefulWidget {
  const ParkingList({Key? key}) : super(key: key);

  @override
  State<ParkingList> createState() => _ParkingListState();
}

class _ParkingListState extends State<ParkingList> {
  final auth = FirebaseAuth.instance;
  final CollectionReference collectionRef =
  FirebaseFirestore.instance.collection("Parking_Create");

  @override
  Widget build(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser!.email!;
    final Stream<QuerySnapshot> _userStrem = FirebaseFirestore.instance
        .collection("Parking_Create")
        .where('Email', isEqualTo: email)
        .snapshots();

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 75,
        title: Text('ลานจอดรถของฉัน',style: TextStyle(
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
      floatingActionButton: buildMessageButton(),
      body: SizedBox(
        width: w,
        height: h,
        child: Column(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                //color: Colors.deepOrange,
                width: w,
                height: h * 0.8869,
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
                                        MaterialPageRoute(builder: (context) => ParkingCheckUI(
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
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(w * 0.78,h * 0.010,0,0),
                                child: Material(
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.black87,
                                    ),
                                    onPressed: () {
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => editParkingUI(
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
                                    iconSize: 25.0,
                                  ),
                                  color: Colors.white,
                                  elevation: 2.5,
                                  borderRadius: BorderRadius.circular(25),
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
  Widget buildMessageButton() => FloatingActionButton.extended(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
    ),
    foregroundColor: Colors.white,
    backgroundColor: Color(0xFF4FCC80),
    icon: Icon(Icons.add,),
    label: Text('เพิ่มลานจอดรถ',style: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 14
    ),),
    elevation: 10,
    onPressed: (){
      Navigator.push(context,
        MaterialPageRoute(builder: (context){
          return fcParkCreateUI();
        }
        ),
      );
    },
  );
}
// Padding(
//   padding: const EdgeInsets.only(bottom: 15),
//   child: Stack(
//     children: [
//       Center(
//         child: Material(
//           color: Colors.white,
//           elevation: 7,
//           borderRadius: BorderRadius.circular(30),
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           child: InkWell(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Ink.image(image: AssetImage('assets/images/near.png'),
//                   width: w * 0.85,
//                   height: h * 0.2,
//                   fit: BoxFit.cover,
//                 ),
//                 SizedBox(height: 6,),
//                 Text('FcPark - ที่จอดรถข้างมหาาิทยาลัยเอเชียอาคเนย์',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 SizedBox(height: 7,),
//               ],
//             ),
//           ),
//         ),
//       ),
//       Padding(
//         padding: EdgeInsetsDirectional.fromSTEB(w * 0.71,h * 0.008,0,0),
//         child: Material(
//           child: IconButton(
//             icon: const Icon(
//               Icons.edit,
//               color: Colors.black87,
//             ),
//             onPressed: () {
//               Navigator.push(context,
//                 MaterialPageRoute(builder: (context){
//                   return editParkingUI();
//                 }
//                 ),
//               );
//             },
//             iconSize: 25.0,
//           ),
//           color: Colors.white,
//           elevation: 2.5,
//           borderRadius: BorderRadius.circular(25),
//         ),
//       ),
//     ],
//   ),
// ),
// Padding(
//   padding: const EdgeInsets.only(bottom: 20),
//   child: Stack(
//     children: [
//       Center(
//         child: Material(
//           color: Colors.white,
//           elevation: 7,
//           borderRadius: BorderRadius.circular(30),
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           child: InkWell(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Ink.image(image: NetworkImage('https://www.teedin108.com/public/photo/original/2013051410203291272.jpg'),
//                   width: w * 0.85,
//                   height: h * 0.2,
//                   fit: BoxFit.cover,
//                 ),
//                 SizedBox(height: 6,),
//                 Text('FcPark - ที่จอดรถถนนสายใยรัก',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 SizedBox(height: 7,),
//               ],
//             ),
//           ),
//         ),
//       ),
//       Padding(
//     padding: EdgeInsetsDirectional.fromSTEB(w * 0.71,h * 0.008,0,0),
//     child: Material(
//       child: IconButton(
//         icon: const Icon(
//           Icons.edit,
//           color: Colors.black87,
//         ),
//         onPressed: () {
//           Navigator.push(context,
//             MaterialPageRoute(builder: (context){
//               return editParkingUI();
//             }
//             ),
//           );
//         },
//         iconSize: 25.0,
//       ),
//       color: Colors.white,
//       elevation: 2.5,
//       borderRadius: BorderRadius.circular(25),
//     ),
//   ),
//     ],
//   ),
// ),