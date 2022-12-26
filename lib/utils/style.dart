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
    Text showTitleH2T(String title) => Text(
      title,
      style: TextStyle(
        fontSize: 18.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Lato',
      ),
    );



    BoxDecoration myBoxDecoretion(String namePic) {
      return BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/$namePic'), fit: BoxFit.cover),
      );
    }

    Container showLogo2() {
      return Container(
        width: 250.0,
        child: Image.asset('assets/images/app_icon.jpg'),
      );
    }

    TextStyle mainTitle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Color.fromARGB(255, 69, 111, 196),
    );

    TextStyle mainConfirmTitle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Color.fromARGB(255, 9, 82, 142),
    );

    TextStyle mainh2Title = TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    TextStyle mainh4Title = TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    TextStyle mainh23Title = TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    TextStyle mainhATitle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.blueAccent,
    );
    TextStyle mainhPTitle = TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.bold,
      color: Color(0xff2972ff),
    );

    TextStyle mainh1Title = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    TextStyle mainh3Title = TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );



  }