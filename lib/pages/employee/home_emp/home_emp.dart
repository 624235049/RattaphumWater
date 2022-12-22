




import 'package:flutter/material.dart';

import '../../../utils/logout.dart';


class HomeEmp extends StatefulWidget {
  const HomeEmp({Key? key}) : super(key: key);

  @override
  State<HomeEmp> createState() => _HomeEmpState();
}

class _HomeEmpState extends State<HomeEmp> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Employee Page" ,style: TextStyle(color: Colors.indigo),),
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
