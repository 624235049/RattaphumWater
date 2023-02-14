
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rattaphumwater/pages/screen/splash_screen.dart';
import 'configs/app_route.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

