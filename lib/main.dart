import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_fcpark/bloc/application_bloc.dart';
import 'package:flutter_app_fcpark/screen/introScreen.dart';
import 'package:flutter_app_fcpark/screen/loginScreen.dart';
import 'package:flutter_app_fcpark/screen/parking_create.dart';
import 'package:flutter_app_fcpark/screen/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_fcpark/splashScreen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    ),
  );
}