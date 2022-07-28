import 'package:flutter/material.dart';
import 'package:flutter_app_fcpark/screen/home.dart';

class AllParkingUI extends StatefulWidget {
  const AllParkingUI({Key? key}) : super(key: key);

  @override
  State<AllParkingUI> createState() => _AllParkingUIState();
}

class _AllParkingUIState extends State<AllParkingUI> {
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 17),
                child: Text("──────────   All Car Park   ───────────",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff888888),
                    fontSize: 16,
                  ),
                ),
              ),

            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
