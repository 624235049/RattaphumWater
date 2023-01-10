import 'package:flutter/material.dart';

import '../../../utils/logout.dart';
import '../screen/account_page.dart';
import '../screen/cart_history_page.dart';
import '../screen/main_water_page.dart';
import '../screen/history_page.dart';



class HomeCs extends StatefulWidget {
  const HomeCs({Key? key}) : super(key: key);

  @override
  State<HomeCs> createState() => _HomeCsState();
}

class _HomeCsState extends State<HomeCs> {

  int _selectedIndex = 0;


  List pages = [
    const MainWaterPage(),
    const HistoryPage(),
    const CartHistoryPage(),
    const AccountPage(),
  ];

  void onTapNav(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Customer Page" ,style: TextStyle(color: Colors.indigo),),
        iconTheme: IconThemeData(color: Colors.indigo),
        actions: [
          IconButton(
            icon: Icon(Icons.cancel , color: Colors.indigo , size: 32,),
            onPressed: () => signOutProcess(context),
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0.0,
        unselectedFontSize: 0.0,
        currentIndex: _selectedIndex,
        onTap: onTapNav,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive),
            label: "history",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "carts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "profile",
          ),
        ],
      ),

    );
  }
}
