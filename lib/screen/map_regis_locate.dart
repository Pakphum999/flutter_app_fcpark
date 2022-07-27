import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_fcpark/bloc/application_bloc.dart';
import 'package:flutter_app_fcpark/screen/home.dart';
import 'package:flutter_app_fcpark/screen/parking_create.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapRegisUI extends StatefulWidget {
  const MapRegisUI({Key? key}) : super(key: key);
  @override
  State<MapRegisUI> createState() => _MapRegisUIState();
}

class _MapRegisUIState extends State<MapRegisUI> {
  int bnbIndex = 0;
  List x = [];
  //สร้างตัวควบคุม Google Map
  Completer<GoogleMapController> gooController = Completer();
  //สร้างตัวควบคุม Marker
  Set<Marker> gooMarker = {};
  //สร้างตัวควบคุม Circle
  Set<Circle> gooCircle = {};
  LocationData? currentLocation;

  @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 75,
        title: Text('กรุณาเลือกตำแหน่งของคุณ',style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        ),
        centerTitle: true,
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
      body: (applicationBloc.currentLocation == null)
      ? Center(child: CircularProgressIndicator(),)
      :
      Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  applicationBloc.currentLocation!.latitude,
                  applicationBloc.currentLocation!.longitude
              ),
              zoom: 15,
            ),
            mapType: MapType.normal,
            markers: gooMarker,
            circles: gooCircle,
            onMapCreated: (GoogleMapController controller) {
              //เอาตัว controller ที่สร้างมากำหนดให้กับ Google Map นี้
              gooController.complete(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
            onTap: (location) {
              x = [location.latitude.toDouble(),location.longitude.toDouble()];

              setState((){
                gooMarker.add(
                    Marker(
                      markerId: MarkerId('place_name'),
                      position: LatLng(location.latitude, location.longitude),
                      infoWindow: const InfoWindow(
                        title: 'ตำแหน่ง',
                        snippet: 'คุณอยู่ตรงนี้',
                      ),
                    )
                );
              });

            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop(x);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  fixedSize: Size(200, 45.0),
                  primary: const Color(0xff429D65),
                ),
                child: const Text(
                  'เลือกตำแหน่งนี้',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
            ),
          ),//bottom
        ],
      )

    );
  }
}
