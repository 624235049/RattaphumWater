import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rattaphumwater/configs/api.dart';
import 'package:rattaphumwater/model/product_model.dart';

import '../../../../../utils/dialog.dart';
import '../../../../../utils/style.dart';



class EditProduct extends StatefulWidget {
  final ProductModel productModel;

  EditProduct({Key? key, required this.productModel}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late ProductModel productModel;
  File? file;
  String? brand_name ,size,price,quantity,product_img,product_id;
  String selectedValue = "Crystal";

  @override
  void initState() {
    productModel = widget.productModel;
    product_id = productModel.waterId;
    brand_name = productModel.brandName;
    size = productModel.size;
    price = productModel.price;
    product_img = productModel.waterImage;
    quantity = productModel.quantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit ${brand_name} Product id: ${product_id}",
          style: TextStyle(color: Colors.indigo),
        ),
        iconTheme: IconThemeData(color: Colors.indigo),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            groupImage(),
            Style().mySizebox(),
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
            // AppTextFieldString(text: size!, hintText: "ขนาด", icon: Icons.price_change),
            // AppTextFieldString(text: price!, hintText: "ราคา", icon: Icons.price_change),
            // AppTextFieldString(text: quantity!, hintText: "จำนวน", icon: Icons.price_change),
            sizeWater(),
            priceWater(),
            qtyWater(),
            saveButton(),
          ],
        ),
      ),

    );
  }


  Widget priceWater() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(top: 16.0),
        width: 300.0,
        child: TextFormField(
          onChanged: (value) => price = value.trim(),
          initialValue: price,
          decoration: InputDecoration(
            labelText: 'ราคา',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ],
  );


  Widget sizeWater() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(top: 16.0),
        width: 300.0,
        child: TextFormField(
          onChanged: (value) => size = value.trim(),
          initialValue: size,
          decoration: InputDecoration(
            labelText: 'ขนาด',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ],
  );

  Widget qtyWater() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(top: 16.0),
        width: 300.0,
        child: TextFormField(
          onChanged: (value) => quantity = value.trim(),
          initialValue: quantity,
          decoration: InputDecoration(
            labelText: 'จำนวน',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ],
  );

  Widget saveButton() {
    return Container(
      width: 200.0,
      child: RaisedButton.icon(
        color: Colors.blueAccent,
        onPressed: () {
          if (size!.isEmpty || price!.isEmpty) {
            normalDialog(context, 'กรุณากรอกให้ครบทุกช่อง !');
          } else {
            confirmEdit();
          }
        },
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          'Save',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }



  Future<Null> confirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการเปลี่ยนแปลงรายการนี้ใช่ไหม ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  editproductMySQL();
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                label: Text(
                  'ตกลง',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Text(
                  'ยกเลิก',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        ],
      ),
    );
  }


  // Future<Null> editproductMySQL() async {
  //   Random random = Random();
  //   int i = random.nextInt(100000);
  //   String nameFile = 'editbrand$i.jpg';
  //   Map<String, dynamic> map = Map();
  //   map['file'] = await MultipartFile.fromFile(file!.path, filename: nameFile);
  //   FormData formData = FormData.fromMap(map);
  //   String urlUpload = '${API().BASE_URL}/rattaphumwater/saveProductWater.php';
  //   await Dio().post(urlUpload, data: formData).then((value) async {
  //      crystal_img = '/rattaphumwater/product/$nameFile';
  //
  //     String url =
  //         '${API().BASE_URL}';
  //     await Dio().get(url).then(
  //           (value) {
  //         if (value.toString() == 'true') {
  //           Navigator.pop(context);
  //         } else {
  //           normalDialog(context, 'กรุณาลองใหม่มีอะไรผิดพลาด!');
  //         }
  //       },
  //     );
  //   });
  // }

  Future<Null> editproductMySQL() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String nameFile = 'editavatar$i.jpg';
    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(file!.path, filename: nameFile);
    FormData formData = FormData.fromMap(map);
    String urlUpload = '${API().BASE_URL}/rattaphumwater/saveProductWater.php';
    await Dio().post(urlUpload, data: formData).then((value) async {
       product_img = '/rattaphumwater/product/$nameFile';
      String url =
          '${API().BASE_URL}/rattaphumwater/editProductWhereId.php?isAdd=true&water_id=$product_id&waterImg=$product_img&brand_name=$brand_name&price=$price&size=$size&quantity=$quantity';
      await Dio().get(url).then(
            (value) {
          Navigator.pop(context);
          print('Edit Crystal Success');
          print( " product_id ===> ${product_id} image ====>> ${product_img}");
        },
      );
    });
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
        width: 200.0,
        height: 200.0,
        child: file == null
            ? Image.network(
          '${API().BASE_URL}${productModel.waterImage}',
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
