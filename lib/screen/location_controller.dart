import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app_fcpark/screen/location_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice/src/places.dart';



class locationController extends GetxController{
  Placemark _pickPlaceMark = Placemark();
  Placemark get pickPlaceMark => _pickPlaceMark;

  List<Prediction> _predictionList = [];

  Future<List<Prediction>> searchLocation(BuildContext context, String text) async{
    if(text != null && text.isEmpty){
      http.Response response = await getlocationData(text);
      var data = jsonDecode(response.body.toString());
      print("my status " + data["status"]);
      if(data['status' == 'OK']){
        _predictionList = [];
        data['prediction'].forEach((prediction)
        => _predictionList.add(Prediction.fromJson(prediction)));
      }else{}
    }
    return _predictionList;
  }
}