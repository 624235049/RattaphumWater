
import 'package:flutter/material.dart';
import 'package:rattaphumwater/pages/admin/home_admin/home_admin.dart';
import 'package:rattaphumwater/pages/admin/screen/CRUD/CRUD_CS/add_account.dart';
import 'package:rattaphumwater/pages/admin/screen/CRUD/CRUD_CS/show_customer.dart';
import 'package:rattaphumwater/pages/admin/screen/CRUD/CRUD_EMP/add_account.dart';
import 'package:rattaphumwater/pages/admin/screen/CRUD/CRUD_EMP/show_emp.dart';
import 'package:rattaphumwater/pages/admin/screen/CRUD/add_category.dart';
import 'package:rattaphumwater/pages/admin/screen/CRUD/namthip/namthip_product.dart';
import 'package:rattaphumwater/pages/admin/screen/CRUD/nestle/product_nestle.dart';
import 'package:rattaphumwater/pages/admin/screen/CRUD/sing/sing_product.dart';
import 'package:rattaphumwater/pages/customer/home_cs/home_cs.dart';
import 'package:rattaphumwater/pages/employee/home_emp/home_emp.dart';
import 'package:rattaphumwater/register/register_page.dart';

import '../pages/admin/screen/CRUD/crystal/product_crystal.dart';
import '../pages/home/home.dart';
class AppRoute {

  static const homeRoute = "home";
  static const registerRoute = "Register";
  static const homeAdmin = "HomeAdmin";
  static const homeCs = "HomeCustomer";
  static const homeEmp = "HomeEmp";
  static const namthip_product = "NamthipProduct";
  static const nestle_product = "NestleProduct";
  static const crystal_product = "CrystalProduct";
  static const sing_product = "SingProduct";
  static const add_product = "AddProductCateGory";
  static const show_account = "ShowAccount";
  static const add_accountemp = "AddAccountEmp";
  static const addccountecs = "AddAccountCs";
  final _route = <String, WidgetBuilder>{

    homeRoute: (context) =>  HomePage(),
    registerRoute: (context) => RegisterPage(),
    homeAdmin: (context) => HomeAdmin(),
    homeCs: (context) => HomeCs(),
    homeEmp: (context) => HomeEmp(),
    namthip_product: (context) => NamthipProduct(),
    nestle_product: (context) => NestleProduct(),
    crystal_product: (context) => CrystalProduct(),
    sing_product: (context) => SingProduct(),
    add_product: (context) => AddCateGory(),
    show_account: (context) => ShowAccount(),
    add_accountemp: (context) => AddAccountEmp(),
    addccountecs: (context) => AddAccountCs(),
  };

  get getAll => _route;
}