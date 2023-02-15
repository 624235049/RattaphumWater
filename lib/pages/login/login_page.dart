
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rattaphumwater/configs/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/app_route.dart';
import '../../model/user_model.dart';
import '../../utils/dialog.dart';
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

  final formKey = GlobalKey<FormState>();


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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: const BoxDecoration(),
          child: Center(

            child: Form(
              key: formKey,
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
        ),
      ),
    );
  }


  Widget LoginButton() => Container(
    width: 250.0,
    child: RaisedButton(
      color: Colors.indigoAccent,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          checkAuthen();
        }
        },
      child: const Text(
        'เข้าสู่ระบบ',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );

  Future<Null> checkAuthen() async {

    var email =   _usernameController.text;
    var password = _passwordController.text;

    String url =
        '${API().BASE_URL}/rattaphumwater/getUserWhereUser.php?isAdd=true&User=$email';
    try {
      Response response = await Dio().get(url);
      print('res = $response');

      var result = json.decode(response.data);
      print('result = $result');
      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (password == userModel.password!) {
          String chooseType = userModel.chooseType!;
          if (chooseType == 'Customer') {
            RoutetoService(userModel);
            Navigator.pushNamedAndRemoveUntil(context, AppRoute.homeCs, (route) => false);
          } else if (chooseType == 'Admin') {
            RoutetoService(userModel);
            Navigator.pushNamedAndRemoveUntil(context, AppRoute.homeAdmin, (route) => false);
          } else if (chooseType == 'Employee') {
            RoutetoService(userModel);
            Navigator.pushNamedAndRemoveUntil(context, AppRoute.homeEmp, (route) => false);
          } else {
            normalDialog(context, 'Error!');
          }
        } else {
          normalDialog(context, 'Password ผิด กรุณาลองใหม่อีกครั้ง ค่ะ');
        }
      }
    } catch (e) {
      normalDialog(context, 'Password ผิด กรุณาลองใหม่อีกครั้ง ค่ะ');
    }
  }

  Future<Null> RoutetoService( UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(API().keyId, userModel.id!);
    preferences.setString(API().keyType, userModel.chooseType!);
    preferences.setString(API().keyName, userModel.name!);

  }

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
    child: TextFormField(
      keyboardType: TextInputType.name,
      controller: _usernameController,
      validator: (value) {
        if (value.toString().isEmpty) {
          return 'กรุณากรอก email ด้วย ค่ะ';
        } else {}
      },
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
    child: TextFormField(
      obscureText: isHidden,
      controller: _passwordController,
      validator: (value) {
        if (value.toString().isEmpty) {
          return 'กรุณากรอก password ด้วย ค่ะ';
        } else {}
      },
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


