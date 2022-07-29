import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fcpark/screen/all_parking.dart';
import 'package:flutter_app_fcpark/screen/editProfile.dart';
import 'package:flutter_app_fcpark/screen/home.dart';
import 'package:flutter_app_fcpark/screen/loginScreen.dart';
import 'package:flutter_app_fcpark/screen/map_location.dart';
import 'package:flutter_app_fcpark/screen/parking_list.dart';

class TabBarMaterial extends StatefulWidget {
  const TabBarMaterial({Key? key}) : super(key: key);

  @override
  State<TabBarMaterial> createState() => _TabBarMaterialState();
}

class _TabBarMaterialState extends State<TabBarMaterial> {
  @override
  Widget build(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser!.email!;

    final Stream<QuerySnapshot> _userStrem = FirebaseFirestore.instance
        .collection("register")
        .where('Email', isEqualTo: email)
        .snapshots();
    final placeholder = Opacity(
      opacity: 0,
      child: IconButton(icon: Icon(Icons.no_cell), onPressed: null,),
    );

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 10,

      child: StreamBuilder<QuerySnapshot>(
          stream: _userStrem,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return Row(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.home,size: 30,color: Colors.black54,),
                          onPressed: (){
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(
                                builder: (context) => HomeUI()
                            )
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.location_on,size: 30,color: Colors.black54),
                          onPressed: (){
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context){
                                return AllParkingUI();
                              }
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.person,size: 30,color: Colors.black54,),
                          onPressed: (){
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
                        ),
                        IconButton(
                          icon: Icon(Icons.directions_car,size: 30,color: Colors.black54,),
                          onPressed: (){
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context){
                                return ParkingList();
                              }
                              ),
                            );
                          },
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