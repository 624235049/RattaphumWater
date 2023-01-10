import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rattaphumwater/configs/app_route.dart';
import 'package:rattaphumwater/model/user_model.dart';
import 'package:rattaphumwater/pages/admin/widget/app_text_fiel_string.dart';
import 'package:rattaphumwater/utils/dialog.dart';

import '../../../configs/api.dart';
import '../../../utils/style.dart';
import '../../admin/widget/app_icon.dart';
import '../../admin/widget/big_text.dart';
import '../widget/account_widget.dart';



class EditAccount extends StatefulWidget {
  final UserModel userModel;
  const EditAccount({Key? key, required this.userModel}) : super(key: key);

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  UserModel? userModel;

  String? avatar, name, address, phone, user, password, user_id;
  double? lat, lng;
  File? file;
  bool passwordVisible = true;
  bool confirmPassVissible = true;
  // bool passwordVisible = true;
  // bool confirmPassVissible = true;

  @override
  void initState() {
    findlatlng();
    userModel = widget.userModel;
    user_id = userModel!.id;
    avatar = userModel!.avatar;
    name = userModel!.name!;
    phone = userModel!.phone!;
    address = userModel!.address;
    user = userModel!.user;
    password = userModel!.password;
    super.initState();
  }

  Future<Null> findlatlng() async {
    Position positon = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = positon.latitude;
      lng = positon.longitude;
      print(' lat == $lat , lng == $lng');
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
            icon: Icon(Icons.save , color: Colors.indigo , size: 32,),
            onPressed: () {
              if (
              name == null ||
                  name!.isEmpty ||
                  phone == null ||
                  phone!.isEmpty ||
                  address == null ||
                  address!.isEmpty ||
                  user == null ||
                  user!.isEmpty ||
                  password == null ||
                  password!.isEmpty) {
                normalDialog2(context, 'มีช่องว่าง !', 'กรุณากรอกข้อมูลให้ครบ');
              } else {
                updateProfileandLocation();
              }
            }),
     ],),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 80.0,
            ),
            AppIcon(
              icon: Icons.person,
              backgroundColor: Colors.blueAccent,
              iconColor: Colors.white,
              iconSize: 80,
              size: 150,
            ),
            SizedBox(
              height: 40.0,
            ),
            // AppTextFieldString(text: user!.trim(), hintText: "user", icon: Icons.person),
            // AppTextFieldString(text: password!.trim(), hintText: "password", icon: Icons.person),
            // AppTextFieldString(text: name!.trim(), hintText: "name", icon: Icons.person),
            // AppTextFieldString(text: phone!.trim(), hintText: "phone", icon: Icons.person),
            // AppTextFieldString(text: address!.trim(), hintText: "address", icon: Icons.person),
            userForm(),
            passwordForm(),
            nameUser(),
            phonesUser(),
            addressUser(),
            buildMap(),

          ],
        ),
      ),


    );
  }

  Widget nameUser() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(top: 16.0),
        width: 300.0,
        child: TextFormField(
          onChanged: (value) => name = value.trim(),
          initialValue: name,
          decoration: InputDecoration(
            labelText: 'name-surname',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ],
  );

  Widget userForm() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(top: 16.0),
        width: 300.0,
        child: TextFormField(
          onChanged: (value) => user = value.trim(),
          initialValue: user,
          decoration: InputDecoration(
            labelText: 'user',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ],
  );

  Widget passwordForm() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(top: 16.0),
        width: 300.0,
        child: TextFormField(
          onChanged: (value) => password = value.trim(),
          obscureText: passwordVisible,
          initialValue: password,
          decoration: InputDecoration(
            labelText: 'password',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                passwordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.black54,
              ),
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
            ),
          ),
        ),
      ),
    ],
  );

  Widget phonesUser() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(top: 16.0),
        width: 300.0,
        child: TextFormField(
          onChanged: (value) => phone = value.trim(),
          initialValue: phone,
          decoration: InputDecoration(
            labelText: 'phone',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ],
  );

  Widget addressUser() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(top: 16.0),
        width: 300.0,
        child: TextFormField(
          onChanged: (value) => address = value.trim(),
          initialValue: address,
          decoration: InputDecoration(
            labelText: 'address',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ],
  );

  Future<Null> updateProfileandLocation() async {
    // Random random = Random();
    // int i = random.nextInt(100000);
    // String nameFile = 'editavatr$i.jpg';
    // Map<String, dynamic> map = Map();
    // map['file'] = await MultipartFile.fromFile(file!.path, filename: nameFile);
    // FormData formData = FormData.fromMap(map);
    // String urlUpload = '${API().BASE_URL}/gas/saveAvatar.php';
    // await Dio().post(urlUpload, data: formData).then((value) async {
    //   avatar = '/rattaphumwater/avatar/$nameFile';

    // print("editProfilelocation.php?isAdd=true&id=$user_id&Avatar=images/none&Name=$name&User=$user&Password=$password&Phone=$phone&Address=$address&Lat=$lat&Lng=$lng");

    String url =
        '${API().BASE_URL}/rattaphumwater/editProfilelocation.php?isAdd=true&id=$user_id&Avatar=images/none&Name=$name&User=$user&Password=$password&Phone=$phone&Address=$address&Lat=$lat&Lng=$lng';

    await Dio().put(url).then(
          (value) {
            Navigator.pop(context);
        normalDialog2(
            context, "แก้ไขข้อมูลสมาชิกสำเร็จ", "กรุณาตรวจสอบเพื่อความถูกต้อง");
      },
    );
  }


  Widget buildMap() => Container(
    color: Colors.grey,
    width: double.infinity,
    height: 300,
    child: lat == null
        ? Style().showProgress()
        : GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(lat!, lng!),
        zoom: 16,
      ),
      onMapCreated: (context) {},
      markers: setMarker(),
    ),
  );

  Set<Marker> setMarker() => <Marker>[
    Marker(
      markerId: MarkerId('id'),
      position: LatLng(lat!, lng!),
      infoWindow: InfoWindow(
          title: 'คุณอยู่ที่นี่ ', snippet: 'lat = $lat, lng = $lng'),
    ),
  ].toSet();
}