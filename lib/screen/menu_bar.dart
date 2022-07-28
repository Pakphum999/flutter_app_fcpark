import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fcpark/screen/editProfile.dart';
import 'package:flutter_app_fcpark/screen/introScreen.dart';
import 'package:flutter_app_fcpark/screen/parking_list.dart';

class MenuBar extends StatefulWidget {

  @override
  State<MenuBar> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  final auth = FirebaseAuth.instance;
  final CollectionReference collectionRef =
  FirebaseFirestore.instance.collection("register");

  @override
  Widget build(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser!.email!;

    final Stream<QuerySnapshot> _userStrem = FirebaseFirestore.instance
        .collection("register")
        .where('Email', isEqualTo: email)
        .snapshots();

    return Drawer(
      backgroundColor: Color(0xffB8B8B8),
      child: StreamBuilder<QuerySnapshot>(
          stream: _userStrem,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return ListView(
                padding: EdgeInsets.zero,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return Column(
                    //padding: EdgeInsets.zero,
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: Text(data['Name']),
                        accountEmail: Text(auth.currentUser!.email!),
                        currentAccountPicture: CircleAvatar(
                          child: ClipOval(
                            child: Image.network(
                              data['Image'],
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://static.vecteezy.com/system/resources/previews/001/589/630/original/green-background-with-fading-square-and-dots-free-vector.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 2,),
                      ListTile(
                        tileColor: Colors.white,
                        leading: Icon(Icons.search_rounded, color: Colors.black,),
                        title: Text('ค้นหาที่จอดรถ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),
                        ),
                        onTap: () => null,
                      ),
                      SizedBox(height: 10,),
                      ListTile(
                        tileColor: Colors.white,
                        leading: Icon(Icons.directions_car, color: Colors.black,),
                        title: Text('ดูลานจอดรถของฉัน',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context){
                              return ParkingList(

                              );
                            }
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10,),
                      ListTile(
                        tileColor: Colors.white,
                        leading: Icon(Icons.edit, color: Colors.black,),
                        title: Text('แก้ไขข้อมูลส่วนตัว',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),
                        ),
                        onTap: () {
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
                      SizedBox(height: 10,),
                      ListTile(
                        tileColor: Color(0xffE37373),
                        leading: Icon(Icons.logout, color: Colors.white,),
                        title: Text('ออกจากระบบ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white
                          ),
                        ),
                        onTap: (){
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                title: Center(
                                  child: Container(
                                    width: double.infinity,
                                    color: Color(0xFF4FCC80),
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
                                      'ต้องการออกจากระบบหรือไม่',
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
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                auth.signOut().then((value){
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                            return introScreenui();
                                                          }
                                                      )
                                                  );
                                                });
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
                        },
                      ),
                    ],
                  );
                }).toList()
            );
          }
      )
    );
  }
}
