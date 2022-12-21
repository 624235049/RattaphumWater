
import 'package:flutter/material.dart';

import '../../configs/app_route.dart';
import '../../utils/style.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {



  bool isHidden = false;

  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();



  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      // appBar: AppBar( title: Center(child: Text("หน้าเข้าสู่ระบบ")),),
      body: Container(
        decoration: const BoxDecoration(),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 80,),
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
      child: const Text(
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
        Navigator.pushNamed(context, AppRoute.registerRoute);
      },
      child: const Text(
        'สมัครสมาชิก',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );

  Widget userForm() => Container(
    margin: EdgeInsets.only(top: 10),
    width: 270.0,
    child: TextField(
      keyboardType: TextInputType.name,
      controller: _usernameController,
      decoration: const InputDecoration(
         prefixIcon:  Icon(
          Icons.account_box,
          color: Colors.blueAccent,
        ),
        labelStyle: TextStyle(
          color: Colors.blue,
        ),
        labelText: 'Email :',
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
      obscureText: isHidden,
      controller: _passwordController,
      decoration: InputDecoration(
        prefixIcon:  Icon(
          Icons.lock,
          color: Colors.blueAccent,
        ),
        labelStyle: TextStyle(
          color: Colors.blue,
        ),
        suffixIcon: IconButton(
            icon: isHidden
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility),
            onPressed: togglePasswordVisibility),
        labelText: 'Password :',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),),

      ),
    ),
  );

  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);


}


