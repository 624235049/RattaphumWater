import 'package:flutter/material.dart';

import '../../../utils/logout.dart';



class HomeCs extends StatefulWidget {
  const HomeCs({Key? key}) : super(key: key);

  @override
  State<HomeCs> createState() => _HomeCsState();
}

class _HomeCsState extends State<HomeCs> {
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
    );
  }
}
