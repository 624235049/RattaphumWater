

import 'package:flutter/material.dart';
import 'package:rattaphumwater/pages/home/home.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
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
}
