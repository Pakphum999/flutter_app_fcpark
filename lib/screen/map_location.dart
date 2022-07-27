import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_fcpark/screen/tabbarmaterial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_app_fcpark/bloc/application_bloc.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class MapLocationUI extends StatefulWidget {
  const MapLocationUI({Key? key}) : super(key: key);

  @override
  State<MapLocationUI> createState() => _MapLocationUIState();
}

class _MapLocationUIState extends State<MapLocationUI> {
  int bnbIndex = 0;

  //สร้างตัวควบคุม Google Map
  Completer<GoogleMapController> gooController = Completer();
  //สร้างตัวควบคุม Marker
  Set<Marker> gooMarker = {};
  //สร้างตัวควบคุม Circle
  Set<Circle> gooCircle = {};

  LocationData? currentLocation;

  Future<LocationData?> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null;
    }
  }

  Future _goToMe() async {
    final GoogleMapController controller = await gooController.future;
    currentLocation = await getCurrentLocation();
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!
        ),
        zoom: 16,
      ),
    )
    );

    MarkerId markerId = MarkerId (currentLocation!.latitude!.toString() + currentLocation!.longitude!.toString());
    setState(() {
      gooMarker.add(
        Marker(
          markerId: markerId,
          position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          infoWindow: const InfoWindow(
            title: 'ตำแหน่ง',
            snippet: 'คุณอยู่ตรงนี้',
          ),
          onTap: () => _openOnGoogleMapApp(currentLocation!.latitude!, currentLocation!.longitude!),
        ),

      );
    });

    CircleId circleId = CircleId(currentLocation!.latitude!.toString() + currentLocation!.longitude!.toString());
    setState(() {
      // gooCircle.add(
      //   Circle(
      //     circleId: circleId,
      //     center: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      //     radius: 200.0,
      //     fillColor: const Color(0x33FF0000),
      //     strokeColor: Colors.transparent,
      //     strokeWidth: 1,
      //   ),
      // );
    });


  }

  _openOnGoogleMapApp(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      // Could not open the map.
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _goToMe();
    // createMarker(37.3743350709, -122.075217962, 'ตำแหน่ง',
    //     'คุณอยู่ตรงนี้');
    // createCircle(37.3743350709, -122.075217962);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Scaffold(

      body: (applicationBloc.currentLocation == null)
          ? Center(child: CircularProgressIndicator(),)
          :
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(18.7942328, 98.8864367),
                zoom: 12,
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
              onTap: (log) {},
            ),

          ],
        ),
      ),

    );
  }
}