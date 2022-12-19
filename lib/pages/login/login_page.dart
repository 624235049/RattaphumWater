
import 'package:flutter/material.dart';

import '../../utils/style.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar( title: Center(child: const Text("หน้าเข้าสู่ระบบ")),),
      body: Container(
        decoration: const BoxDecoration(),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Style().showLogo(),
                Style().mySizebox(),
                userForm(),
                Style().mySizebox(),
                passwordForm(),
                Style().mySizebox(),
                LoginButton(),
                Style().mySizebox(),
                RegisterButton(),
                SizedBox(
                  height: 200,
                ),
              ],

            ),
          ),
        ),
      ),
    );
  }


  Widget LoginButton() => Container(
    width: 250.0,
    child: RaisedButton(
      color: Colors.indigoAccent,
      onPressed: () {
        },
      child: Text(
        'เข้าสู่ระบบ',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );


  Widget RegisterButton() => Container(
    width: 250.0,
    child: RaisedButton(
      color: Colors.indigo,
      onPressed: () {
      },
      child: Text(
        'สมัครสมาชิก',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );

  Widget userForm() => Container(
    margin: EdgeInsets.only(top: 10),
    width: 270.0,
    child: TextField(
      decoration: InputDecoration(
        prefixIcon:  Icon(
          Icons.account_box,
          color: Colors.blueAccent,
        ),
        labelStyle: TextStyle(
          color: Colors.blue,
        ),
        labelText: 'User :',
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),),

    ),
    ),
  );



  Widget passwordForm() => Container(
    margin: EdgeInsets.only(top: 10),
    width: 270.0,
    child: TextField(
      decoration: InputDecoration(
        prefixIcon:  Icon(
          Icons.lock,
          color: Colors.blueAccent,
        ),
        labelStyle: TextStyle(
          color: Colors.blue,
        ),
        labelText: 'Password :',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),),

      ),
    ),
  );




}


