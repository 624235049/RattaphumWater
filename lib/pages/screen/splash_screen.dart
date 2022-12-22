

import 'package:flutter/material.dart';
import 'package:rattaphumwater/configs/api.dart';
import 'package:rattaphumwater/pages/home/home.dart';
import 'package:rattaphumwater/pages/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/app_route.dart';
import '../../utils/dialog.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}




class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkPreference();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
//        }
//      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(25),
              child: SizedBox(),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: Image.asset(
                'assets/images/app_icon.jpg',
                width: 400,
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FittedBox(
                child:  Text(
                  '2019 \u00a9  My Water. All Rights Reserved',
                  style: TextStyle(
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> checkPreference() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? chooseType = preferences.getString(API().keyType);

      if (chooseType != null && chooseType.isNotEmpty) {
        if (chooseType == 'Customer') {
          Navigator.pushNamedAndRemoveUntil(context, AppRoute.homeCs, (route) => false);
          print("preferense customer success");
        } else if (chooseType == 'Admin') {
          Navigator.pushNamedAndRemoveUntil(context, AppRoute.homeAdmin, (route) => false);
          print("preferense adminn success");
        } else if (chooseType == 'Employee') {
          Navigator.pushNamedAndRemoveUntil(context, AppRoute.homeEmp, (route) => false);
          print("preferense employee success");
        } else {
          normalDialog(context, 'Error user Type!');
        }
      }
    } catch (e) {

    }
  }



}
