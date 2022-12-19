import 'package:flutter/material.dart';


  class Style {

    Widget showProgress() {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    SizedBox mySizebox() => const SizedBox(
      width: 8.0,
      height: 16.0,
    );

    Container showLogo() {
      return Container(
        width: 250.0,
        child: Image.asset('assets/images/app_icon.jpg'),
      );
    }



  }