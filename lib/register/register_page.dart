import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rattaphumwater/configs/api.dart';
import 'package:rattaphumwater/utils/dialog.dart';

import '../configs/app_route.dart';
import '../utils/style.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isHidden = false;

  Position? userlocation;
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _phoneController = TextEditingController();
  var _addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  double? lat,lng;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();
    findlatlng();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar( title:  Center(child: Text("หน้าสมัครสมาชิก")),),
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
                    SizedBox(
                      height: 80,
                    ),
                    Style().showLogo(),
                    nameForm(),
                    Style().mySizebox(),
                    userForm(),
                    Style().mySizebox(),
                    phoneForm(),
                    Style().mySizebox(),
                    passwordForm(),
                    Style().mySizebox(),
                    addressForm(),
                    Style().mySizebox(),
                    RegisterButton(),
                    SizedBox(
                      height: 150,
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

  Widget RegisterButton() => Container(
        width: 250.0,
        child: RaisedButton(
          color: Colors.indigo,
          onPressed: () {
            // Navigator.pushNamed(context, AppRoute.homeRoute);
            if (formKey.currentState!.validate()) {
              uploadAndInsertData();
            }
          },
          child: const Text(
            'สมัครสมาชิก',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  Widget nameForm() => Container(
        margin: EdgeInsets.only(top: 10),
        width: 270.0,
        child: TextFormField(
          controller: _nameController,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value.toString().isEmpty) {
              return 'กรุณากรอก name ด้วย ค่ะ';
            } else {}
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: Colors.blueAccent,
            ),
            labelStyle: TextStyle(
              color: Colors.blue,
            ),
            labelText: 'Name :',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      );

  Widget phoneForm() => Container(
        margin: EdgeInsets.only(top: 10),
        width: 270.0,
        child: TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value.toString().isEmpty) {
              return 'กรุณากรอก เบอร์โทร ด้วย ค่ะ';
            } else {}
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.blueAccent,
            ),
            labelStyle: TextStyle(
              color: Colors.blue,
            ),
            labelText: 'Phone :',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 250.0,
            child: TextFormField(
              controller: _addressController,
              validator: (value) {
                if (value.toString().isEmpty) {
                  return 'กรุณากรอก ที่อยู่ ด้วย ค่ะ';
                } else {}
              },
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Address :',
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                  child: Icon(
                    Icons.home,
                    color: Colors.blue,
                  ),
                ),
                labelStyle: TextStyle(
                  color: Colors.blueAccent,
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent)),
              ),
            ),
          ),
        ],
      );

  Widget userForm() => Container(
        margin: EdgeInsets.only(top: 10),
        width: 270.0,
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value.toString().isEmpty) {
              return 'กรุณากรอก email ด้วย ค่ะ';
            } else {}
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: Colors.blueAccent,
            ),
            labelStyle: TextStyle(
              color: Colors.blue,
            ),
            labelText: 'Email :',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
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
            prefixIcon: Icon(
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
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      );

  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);

  //check permission

  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Sevice Location Open');
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission == await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          normalDialog(context, 'ไม่อนุญาติแชร์ Location โปรดแชร์ Location');
        } else {}
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          normalDialog(context, 'ไม่อนุญาติแชร์ Location โปรดแชร์ Location');
        } else {}
      }
    } else {
      print('Service Location Close');
      normalDialog(context,
          'Location service ปิดอยู่ ? กรุณาเปิดตำแหน่งของท่านก่อนใช้บริการค่ะ');
    }
  }

  Future<Null> findlatlng() async {
    Position positon = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
       lat = positon.latitude;
       lng = positon.longitude;
      print(' lat == $lat , lng == $lng');
    });
  }


  //Future function upload data
  Future<Null> uploadAndInsertData() async {
    var name = _nameController.text;
    var address = _addressController.text;
    var phone = _phoneController.text;
    var user = _emailController.text;
    var password = _passwordController.text;
    // print(" name == ${name} ${address}");
    String apipath = '${API().BASE_URL}/rattaphumwater/register.php?isAdd=true&Name=$name&User=$user&Password=$password&ChooseType=Customer&Avatar=null&Phone=$phone&Address=$address&Lat=$lat&Lng=$lng';

    await Dio().get(apipath).then((value) {
      if(value.toString() == 'true') {
        Navigator.pop(context);
      } else {
      normalDialog(context,"ไม่สำเร็จ");
      }
    });
  }
}
