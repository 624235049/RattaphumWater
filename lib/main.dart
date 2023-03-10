

import 'package:flutter/material.dart';
import 'package:rattaphumwater/pages/screen/splash_screen.dart';
import 'configs/app_route.dart';


void main() async {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: AppRoute().getAll,
      home:  SplashScreen(),
    );
  }
}

