import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../configs/api.dart';
import '../../../../../model/user_model.dart';
import '../../../../../utils/dialog.dart';




class EditAccountEmp extends StatefulWidget {

  final UserModel userModel;
  EditAccountEmp({Key? key, required this.userModel}) : super(key: key);


  @override
  State<EditAccountEmp> createState() => _EditAccountEmpState();
}

class _EditAccountEmpState extends State<EditAccountEmp> {
  UserModel? userModel;
  String? avatar, name, address, phone, user, password, user_id;
  double? lat, lng;
  File? file;
  bool passwordVisible = true;
  bool confirmPassVissible = true;

  @override
  void initState() {
    findlatlng();
    userModel = widget.userModel;
    user_id = userModel!.id;
    avatar = userModel!.avatar;
    name = userModel!.name;
    phone = userModel!.phone;
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
        title: Text(
          "Edit Account Employee",
          style: TextStyle(color: Colors.indigo),
        ),
        iconTheme: IconThemeData(color: Colors.indigo),
        actions: [
          IconButton(
            onPressed: () {
              if (name!.isEmpty || phone!.isEmpty) {
                normalDialog(context,'กรุณากรอกข้อมูลให้ครบ');
              } else {
                updateProfileandLocation().then(
                      (value) => Navigator.pop(context),
                );
              }
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // groupImage(),
            userForm(),
            passwordForm(),
            nameUser(),
            phonesUser(),
            addressUser(),
          ],
        ),
      ),
    );
  }



  Future<Null> updateProfileandLocation() async {
    // Random random = Random();
    // int i = random.nextInt(100000);
    // String nameFile = 'editavatr$i.jpg';
    // Map<String, dynamic> map = Map();
    // map['file'] = await MultipartFile.fromFile(file!.path, filename: nameFile);
    // FormData formData = FormData.fromMap(map);
    // String urlUpload = '${API().BASE_URL}/gas/saveAvatar.php';
    // await Dio().post(urlUpload, data: formData).then((value) async {
    //   avatar = '/rattaphumwater/profile/$nameFile';

      String url =
          '${API().BASE_URL}/rattaphumwater/editProfilelocation.php?isAdd=true&id=$user_id&Avatar=${""}&Name=$name&User=$user&Password=$password&Phone=$phone&Address=$address&Lat=$lat&Lng=$lng';

      await Dio().get(url).then(
            (value) {
          print('Edit Profile Success');
        },
      );
    // }

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

  Row groupImage() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      IconButton(
        icon: Icon(Icons.add_a_photo),
        onPressed: () => chooseImage(
          ImageSource.camera,
        ),
      ),
      Container(
        padding: EdgeInsets.all(16.0),
        width: 250.0,
        height: 250.0,
        child: file == null
            ? Image.network(
          '${API().BASE_URL}${avatar}',
          fit: BoxFit.cover,
        )
            : Image.file(file!),
      ),
      IconButton(
        icon: Icon(Icons.add_photo_alternate),
        onPressed: () => chooseImage(
          ImageSource.gallery,
        ),
      )
    ],
  );

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }
}
