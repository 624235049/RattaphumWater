import 'package:flutter/material.dart';



class HomeCs extends StatefulWidget {
  const HomeCs({Key? key}) : super(key: key);

  @override
  State<HomeCs> createState() => _HomeCsState();
}

class _HomeCsState extends State<HomeCs> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("หน้าลูกค้า"),),
    );
  }
}
