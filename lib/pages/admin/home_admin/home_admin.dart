import 'package:flutter/material.dart';

import '../../../utils/logout.dart';
import '../../../utils/style.dart';



class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Admin Page" ,style: TextStyle(color: Colors.indigo),),
        iconTheme: IconThemeData(color: Colors.indigo),
        actions: [
          IconButton(
            icon: Icon(Icons.cancel , color: Colors.indigo , size: 32,),
            onPressed: () => signOutProcess(context),
          ),
        ],
      ),
      drawer: showDrawer(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            buildFoodFilter(),
          ],
        ),
      ),
    );
  }
}

Drawer showDrawer() => Drawer(

  child: ListView(
    children: <Widget>[
      showHeadAdmin(),

    ],
  ),
);


UserAccountsDrawerHeader showHeadAdmin() {
  return UserAccountsDrawerHeader(
    arrowColor: Colors.blueAccent,
      decoration: Style().myBoxDecoretion('app_icon.jpg'),
      currentAccountPicture: Style().showLogo(),
      accountName: Text('Admin Login'),
      accountEmail: Text('abdulloh@gamil.com'));
}



Widget buildFoodFilter() {
  return Container(
    height: 50,
    //color: Colors.red,
    child: ListView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ChoiceChip(
            selectedColor: Colors.blueAccent,
            labelStyle: TextStyle(color: 1 == index ? Colors.white : Colors.black),
            label: Text("test"),
            selected: 1 == index,
            onSelected: (selected) {
            },
          ),
        );
      }),
    ),
  );
}
