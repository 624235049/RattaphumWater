
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
import 'package:rattaphumwater/pages/admin/screen/order_water/print_bill.dart';
import 'package:rattaphumwater/pages/customer/home_cs/home_cs.dart';
import 'package:rattaphumwater/pages/customer/payment/confirm_payment.dart';
import 'package:rattaphumwater/pages/customer/screen/main_water_page.dart';
import 'package:rattaphumwater/pages/customer/screen/screen_order/crystal_list.dart';
import 'package:rattaphumwater/pages/customer/screen/screen_order/namthip_list.dart';
import 'package:rattaphumwater/pages/customer/screen/screen_order/nestle_list.dart';
import 'package:rattaphumwater/pages/customer/screen/screen_order/sing_list.dart';
import 'package:rattaphumwater/pages/employee/home_emp/home_emp.dart';
import 'package:rattaphumwater/pages/employee/home_emp/screen/crud_order/add_order.dart';
import 'package:rattaphumwater/pages/employee/home_emp/screen/crud_order/edit_order.dart';
import 'package:rattaphumwater/register/register_page.dart';

import '../model/order_model.dart';
import '../pages/admin/screen/CRUD/crystal/product_crystal.dart';
import '../pages/customer/screen/follow_delivery_map.dart';
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
  static const crystallistorder = "CrystalListOrder";
  static const namthiplistorder = "NamthipListOrder";
  static const netlelistorder = "NestleListOrder";
  static const singlistorder = "SingListOrder";
  static const confirmpayment = "ConfirmPayment";
  static const home_cd = "HomeCs";
  static const print_bill = "PrintBill";
  static const addorder_emp = "AddOrderEmp";
  static const editorder_emp = "EditOrderEmp";
  static const follow_map_cs = "FollowTrackingDelivery";

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
    crystallistorder: (context) => CrystalListOrder(),
    namthiplistorder: (context) => NamthipListOrder(),
    netlelistorder: (context) => NestleListOrder(),
    singlistorder: (context) => SingListOrder(),
    confirmpayment: (context) => ConfirmPayment(),
    print_bill: (context) => PrintBillWater(),
    home_cd: (context) => HomeCs(),
    addorder_emp: (context) => AddOrderEmp(),
    follow_map_cs: (context) => FollowTrackingDelivery(orderModel: OrderModel(),),
  };

  get getAll => _route;
}