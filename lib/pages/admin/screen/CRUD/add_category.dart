import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rattaphumwater/configs/api.dart';
import 'package:rattaphumwater/pages/admin/widget/app_text_fiel_string.dart';

import '../../../../utils/style.dart';
import '../../widget/app_text_field.dart';

class AddCateGory extends StatefulWidget {
  const AddCateGory({Key? key}) : super(key: key);

  @override
  State<AddCateGory> createState() => _AddCateGoryState();
}

class _AddCateGoryState extends State<AddCateGory> {
  File? file;

  String? brand_name;
  var sizecontroller = TextEditingController();
  var quantitycontroller = TextEditingController();
  var pricecontroller = TextEditingController();
  String selectedValue = "Sing";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Add CateGory",
          style: TextStyle(color: Colors.indigo),
        ),
        iconTheme: IconThemeData(color: Colors.indigo),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            groupImage(),
            Container(
              width: 300,
              child: DropdownButtonFormField(
                value: selectedValue,
                items: dropdownItems,
                onChanged: (String? value) {
                  setState(() {
                    brand_name = value!;
                  });
                },
              ),
            ),
            AppTextField(
                textController: sizecontroller, hintText: "ขนาด", icon: Icons.add),
            AppTextField(
                textController: quantitycontroller, hintText: "จำนวน", icon: Icons.add),
            AppTextField(
                textController: pricecontroller, hintText: "จำนวน", icon: Icons.add),
            SizedBox(
              height: 40,
            ),
            saveButton(),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Namthip"), value: "Namthip"),
      DropdownMenuItem(child: Text("Crystal"), value: "Crystal"),
      DropdownMenuItem(child: Text("Sing"), value: "Sing"),
      DropdownMenuItem(child: Text("Nestle"), value: "Nestle"),
    ];
    return menuItems;
  }

  Widget saveButton() {
    return Container(
      width: 200.0,
      child: RaisedButton.icon(
        color: Colors.blueAccent,
        onPressed: () {
          uploadGasAndInsertData();
        },
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          'Save Gategory',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> uploadGasAndInsertData() async {
    var price = pricecontroller.text;
    var quantity = quantitycontroller.text;
    var size = sizecontroller.text;
    String urlUpload = '${API().BASE_URL}/rattaphumwater/saveProductWater.php';

    Random random = Random();
    int i = random.nextInt(1000000);
    String nameFile = 'water$i.jpg';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);

      await Dio().post(urlUpload, data: formData).then((value) async {
        String water_image = '/rattaphumwater/product/$nameFile';

        String urlInsertData = '${API().BASE_URL}/rattaphumwater/addproductwater.php?isAdd=true&waterImg=$water_image&brand_name=$brand_name&size=$size&quantity=$quantity&price=$price';
        await Dio().get(urlInsertData).then((value) {
          Navigator.pop(context);
        });
      });
    } catch (e) {}
  }

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () => chooseImage(ImageSource.camera),
        ),
        Container(
          width: 250.0,
          height: 250.0,
          child: file == null ? Style().showLogo() : Image.file(file!),
        ),
        IconButton(
          icon: Icon(Icons.add_photo_alternate),
          onPressed: () => chooseImage(ImageSource.gallery),
        ),
      ],
    );
  }

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
