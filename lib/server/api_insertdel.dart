import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_fcpark/models/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/data_park.dart';


Future<bool> apiInsertTimeline(String image ,String name, String email, String username, String password, String confirm_password, String phone_number,
    ) async{
  //สร้าง object เพื่อนไปเก็บที่ firestore database
  Data timeline = Data(
      image: image,
      name: name,
      email: email,
      username: username,
      password: password,
      confirmPassword: confirm_password,
      phoneNumber: phone_number,

  );

  //นำ object แปลงเป็น json แล้วส่งไปที่ firestore database
  try{
    await FirebaseFirestore.instance.collection("register").add(timeline.toJson());
    return true;
  }catch(ex){
    return false;
  }
}

Stream<QuerySnapshot>? apiGetAllLocation(){
  try{
    return FirebaseFirestore.instance.collection('register').snapshots();
  }catch(ex){
    return null;
  }
}

//-------------------------------------------------------------

Future<bool> apiInsertParking(String email,String Image, String parkingName, String name, double latitude,
    double longitude, String phoneNumber, String carTotal, String status, String carCTotal
    ) async{
  //สร้าง object เพื่อนไปเก็บที่ firestore database
  Data_park timeline = Data_park(
    email: email,
    Image: Image,
    parkingName: parkingName,
    name: name,
    latitude: latitude,
    longitude: longitude,
    phoneNumber: phoneNumber,
    carTotal: carTotal,
    status: status,
    carCTotal: carCTotal
  );

  //นำ object แปลงเป็น json แล้วส่งไปที่ firestore database
  try{
    await FirebaseFirestore.instance.collection("Parking_Create").add(timeline.toJson());
    return true;
  }catch(ex){
    return false;
  }
}

Stream<QuerySnapshot>? apiGetParking(){
  try{
    return FirebaseFirestore.instance.collection('Parking_Create').snapshots();
  }catch(ex){
    return null;
  }
}

//---------------------------------------------------------

Future<bool> apiUpdateTimeline(String id, String image ,String name, String email, String username, String password, String confirm_password, String phone_number,
    ) async{
  //สร้าง object เพื่อนไปเก็บที่ firestore database
  Data timeline = Data(
    image: image,
    name: name,
    email: email,
    username: username,
    password: password,
    confirmPassword: confirm_password,
    phoneNumber: phone_number,

  );

  //นำ object แปลงเป็น json แล้วส่งไปที่ firestore database
  try{
    await FirebaseFirestore.instance.collection("register").doc(id).update(timeline.toJson());
    return true;
  }catch(ex){
    return false;
  }
}

//----------------------------------------------------------

Future<bool> apiUpdateParking(String id, String email, String Image, String parkingName, String name, double latitude,
    double longitude, String phoneNumber, String carTotal, String status, String carCTotal
    ) async{
  //สร้าง object เพื่อนไปเก็บที่ firestore database
  Data_park timeline = Data_park(
    email: email,
    Image: Image,
    parkingName: parkingName,
    name: name,
    latitude: latitude,
    longitude: longitude,
    phoneNumber: phoneNumber,
    carTotal: carTotal,
    status: status,
    carCTotal: carCTotal,
  );

  //นำ object แปลงเป็น json แล้วส่งไปที่ firestore database
  try{
    await FirebaseFirestore.instance.collection("Parking_Create").doc(id).update(timeline.toJson());
    return true;
  }catch(ex){
    return false;
  }
}

//-----------------------------------------------------------------

Future<bool> apiDelParking(String id
    ) async{
  try{
    await FirebaseFirestore.instance.collection("Parking_Create").doc(id).delete();
    return true;
  }catch(ex){
    return false;
  }
}

//----------------------------------------------------------------------

// Future<bool> apiInsertParkingStats(String email, String status, String carCTotal) async{
//   //สร้าง object เพื่อนไปเก็บที่ firestore database
//   DataStats timeline = DataStats(
//     email: email,
//     status: status,
//     carCTotal: carCTotal,
//   );
//
//   //นำ object แปลงเป็น json แล้วส่งไปที่ firestore database
//   try{
//     await FirebaseFirestore.instance.collection("Parking_Stats").add(timeline.toJson());
//     return true;
//   }catch(ex){
//     return false;
//   }
// }

// Future<bool> apiUpdateParkingStats(String id, String email, String status, String carCTotal) async{
//   //สร้าง object เพื่อนไปเก็บที่ firestore database
//   Data_park timeline = Data_park(
//     email: email,
//     status: status,
//     carCTotal: carCTotal,
//   );
//
//   //นำ object แปลงเป็น json แล้วส่งไปที่ firestore database
//   try{
//     await FirebaseFirestore.instance.collection("Parking_Create").doc(id).update(timeline.toJson());
//     return true;
//   }catch(ex){
//     return false;
//   }
// }