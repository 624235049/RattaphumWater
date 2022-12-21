
import 'package:flutter/material.dart';
import 'package:rattaphumwater/register/register_page.dart';

import '../pages/home/home.dart';
class AppRoute {

  static const homeRoute = "home";
  static const registerRoute = "Register";

  final _route = <String, WidgetBuilder>{

    homeRoute: (context) =>  HomePage(),
    registerRoute: (context) => RegisterPage(),


  };

  get getAll => _route;
}