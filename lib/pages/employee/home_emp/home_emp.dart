




import 'package:flutter/material.dart';


class HomeEmp extends StatefulWidget {
  const HomeEmp({Key? key}) : super(key: key);

  @override
  State<HomeEmp> createState() => _HomeEmpState();
}

class _HomeEmpState extends State<HomeEmp> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("หน้าพนักงาน"),),
    );
  }
}
