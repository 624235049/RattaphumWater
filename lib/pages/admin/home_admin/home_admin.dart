



import 'package:flutter/material.dart';
import 'package:rattaphumwater/pages/admin/screen/CRUD/CRUD_CS/show_customer.dart';
import 'package:rattaphumwater/pages/admin/screen/CRUD/CRUD_EMP/show_emp.dart';
import 'package:rattaphumwater/pages/admin/screen/CRUD/category.dart';
import 'package:rattaphumwater/pages/admin/screen/order_water/order_water.dart';

import '../../../configs/app_route.dart';
import '../../../utils/logout.dart';
import '../../../utils/style.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  Widget currentWidget = CateGory();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Admin Page",
          style: TextStyle(color: Colors.indigo),
        ),
        iconTheme: IconThemeData(color: Colors.indigo),
        actions: [
          IconButton(
            icon: Icon(
              Icons.cancel,
              color: Colors.indigo,
              size: 32,
            ),
            onPressed: () => signOutProcess(context),
          ),
        ],
      ),
      drawer: showDrawer(),
      body: currentWidget
    );
  }
  Drawer showDrawer() => Drawer(
    child: ListView(
      children: <Widget>[
        showHeadAdmin(),
        productMenu(),
        orderMenu(),
        personEmpMenu(),
        personCsMenu(),
      ],
    ),
  );

  ListTile orderMenu() => ListTile(
    leading: Icon(
      Icons.shop,
      color: Colors.blue,
    ),
    title: Text('ข้อมูลการสั่งน้ำดื่ม',style: TextStyle(fontWeight: FontWeight.w400 , fontSize: 18), ),
    // subtitle: Text('รายการแก๊สที่ยังไม่ได้ส่งลูกค้า'),
    onTap: () {
      setState(() {
        currentWidget = OrderWater();
      });
      Navigator.pop(context);
    },
  );

  ListTile personEmpMenu() => ListTile(
    leading: Icon(
      Icons.person_add,
      color: Colors.blue,
    ),
    title: Text('จัดการข้อมูลพนักงาน',style: TextStyle(fontWeight: FontWeight.w400 , fontSize: 18), ),
    // subtitle: Text('รายการแก๊สที่ยังไม่ได้ส่งลูกค้า'),
    onTap: () {
      setState(() {
        currentWidget = ShowAccount();
      });
      Navigator.pop(context);
    },
  );

  ListTile personCsMenu() => ListTile(
    leading: Icon(
      Icons.person_search_rounded,
      color: Colors.blue,
    ),
    title: Text('จัดการข้อมูลลูกค้า',style: TextStyle(fontWeight: FontWeight.w400 , fontSize: 18), ),
    // subtitle: Text('รายการแก๊สที่ยังไม่ได้ส่งลูกค้า'),
    onTap: () {
      setState(() {
        currentWidget = ShowAccountCs();
      });
      Navigator.pop(context);
    },
  );


  ListTile productMenu() => ListTile(
    leading: Icon(
      Icons.home,
      color: Colors.blue,
    ),
    title: Text('ข้อมูลสินค้า',style: TextStyle(fontWeight: FontWeight.w400 , fontSize: 18), ),
    // subtitle: Text('รายการแก๊สที่ยังไม่ได้ส่งลูกค้า'),
    onTap: () {
      setState(() {
        currentWidget = CateGory();
      });
      Navigator.pop(context);
    },
  );


  UserAccountsDrawerHeader showHeadAdmin() {
    return UserAccountsDrawerHeader(
        arrowColor: Colors.blueAccent,
        decoration: Style().myBoxDecoretion('app_icon.jpg'),
        currentAccountPicture: Style().showLogo(),
        accountName: Text('Admin Login'),
        accountEmail: Text('abdulloh@gamil.com'));
  }
}




