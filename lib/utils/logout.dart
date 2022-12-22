

import 'package:flutter/material.dart';
import 'package:rattaphumwater/pages/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Null> signOutProcess(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();
  // exit(0);

  MaterialPageRoute route = MaterialPageRoute(
    builder: (context) => LoginPage(),
  );
  Navigator.pushAndRemoveUntil(context, route, (route) => false);
}
