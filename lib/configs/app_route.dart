
import 'package:flutter/material.dart';
import 'package:rattaphumwater/pages/admin/home_admin/home_admin.dart';
import 'package:rattaphumwater/pages/customer/home_cs/home_cs.dart';
import 'package:rattaphumwater/pages/employee/home_emp/home_emp.dart';
import 'package:rattaphumwater/register/register_page.dart';

import '../pages/home/home.dart';
class AppRoute {

  static const homeRoute = "home";
  static const registerRoute = "Register";
  static const homeAdmin = "HomeAdmin";
  static const homeCs = "HomeCustomer";
  static const homeEmp = "HomeEmp";

  final _route = <String, WidgetBuilder>{

    homeRoute: (context) =>  HomePage(),
    registerRoute: (context) => RegisterPage(),
    homeAdmin: (context) => HomeAdmin(),
    homeCs: (context) => HomeCs(),
    homeEmp: (context) => HomeEmp(),

  };

  get getAll => _route;
}