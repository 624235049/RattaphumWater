import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rattaphumwater/configs/app_route.dart';
import 'package:rattaphumwater/pages/admin/widget/app_text_fiel_string.dart';
import 'package:rattaphumwater/utils/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../configs/api.dart';
import '../../../helper/sqlite_helper.dart';
import '../../../model/cart_model.dart';
import '../../../model/user_model.dart';
import '../../../utils/dialog.dart';

class ConfirmPayment extends StatefulWidget {
  const ConfirmPayment({Key? key}) : super(key: key);

  @override
  State<ConfirmPayment> createState() => _ConfirmPaymentState();
}

class _ConfirmPaymentState extends State<ConfirmPayment> {
  List<CartModel> cartModels = [];
  String? dateTimeString;
  File? file;
  int total = 0;
  UserModel? model;
  String? name, phone, address;

  @override
  void initState() {
    super.initState();
    readSQLite();
    findCurrentTime();
    readDataUser();

  }

  Future<Null> readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user_id = preferences.getString('id');
    String url =
        '${API()
        .BASE_URL}/rattaphumwater/getuserwhereid.php?isAdd=true&id=$user_id';

    await Dio().get(url).then((value) {

      if(value.toString() != 'null') {
        var result = json.decode(value.data);

        for (var map in result) {
          setState(() {
             model = UserModel.fromJson(map);
            name = model!.name;
            phone = model!.phone;
            address = model!.address;
          });
        }
      }
    });
  }

  void findCurrentTime() {
    DateTime dateTime = DateTime.now();
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    setState(() {
      dateTimeString = dateFormat.format(dateTime);
    });
  }


  void _pickImage(ImageSource source) async {
    var result = await ImagePicker().getImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    setState(() {
      file = File(result!.path);
    });
  }

  Future<Null> readSQLite() async {
    var object = await SQLiteHelper().readAllDataFormSQLite();
    print('object length ==> ${object.length}');
    if (object.length != 0) {
      for (var model in object) {
        String? sumString = model.sum;
        int sumInt = int.parse(sumString!);
        setState(() {
          cartModels = object;
          total = total + sumInt;
        });
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "CheckOur Order",
          style: TextStyle(color: Colors.indigo),
        ),
        iconTheme: IconThemeData(color: Colors.indigo),
      ),
      body: model != null ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              AppTextFieldString(
                  text: name == "" ? ".." : name!,
                  hintText: "ชื่อ",
                  icon: Icons.person),
              AppTextFieldString(
                  text: address == "" ? ".." : address!,
                  hintText: "ที่อยู่",
                  icon: Icons.add_location),
              AppTextFieldString(
                  text: phone == "" ? ".." : phone!,
                  hintText: "เบอร์โทร",
                  icon: Icons.person),
              SizedBox(height: 16.0),
              file == null ? Text('No image selected.') : Image.file(file!),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.grey,
                child: Text(
                  'Select Image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
              SizedBox(height: 16.0),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.indigo,
                child: Text(
                  'Confirm Order',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                 if(file != null) {
                   orderThread();
                 } else {
                   normalDialog(context, "กรุนาแนบใบเสร็จก่อนสั่งซื้อ");
                 }
                },
              ),
              SizedBox(height: 16.0),
              buildwarning(),
            ],
          ),
        ),
      ) : Style().showProgress(),
    );
  }

  Future<Null> orderThread() async {
    DateTime dateTime = DateTime.now();
    // print(dateTime.toString());
    String order_date_time = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    String distance = cartModels[0].distance!;
    String transport = cartModels[0].transport!;
    List<String> water_ids = [];
    List<String> brand_waters = [];
    List<String> sizes = [];
    List<String> prices = [];
    List<String> amounts = [];
    List<String> sums = [];

    for (var model in cartModels) {
      water_ids.add(model.water_id!);
      brand_waters.add(model.brand_water!);
      prices.add(model.price!);
      sizes.add(model.size!);
      amounts.add(model.amount!);
      sums.add(model.sum!);
    }
    String water_id = water_ids.toString();
    String brand_water = brand_waters.toString();
    String price = prices.toString();
    String size = sizes.toString();
    String amount = amounts.toString();
    String sum = sums.toString();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user_id = preferences.getString('id');
    String? user_name = preferences.getString('Name');
    print(
        'orderDateTime == $order_date_time ,user_id ==> $user_id,user_name ==> $user_name , distance ==> $distance, transport ==> $transport');
    print(
        'water_ids ==> $water_ids ,brand_water ==> $brand_waters, price ==> $price , amount ==> $amount , sum ==> $sum');

    String url =
        '${API()
        .BASE_URL}/rattaphumwater/addOrder.php?isAdd=true&order_date_time=$order_date_time&user_id=$user_id&user_name=$user_name&water_id=$water_id&size=$size&distance=$distance&transport=$transport&brand_water=$brand_water&price=$price&amount=$amount&sum=$sum&emp_id=none&payment_status=payondelivery&status=userorder';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        // updateQtyGas(amount, gas_id);
        clearOrderSQLite();
        processUploadInsertData();

      } else {
        normalDialog(context, 'ไม่สามารถสั่งซื้อได้กรุณาลองใหม่');
      }
    });
  }

  Future<Null> clearOrderSQLite() async {
    await SQLiteHelper().deleteAllData().then(
          (value) {
            Navigator.pop(context);
          normalDialog2(context, "สั่งซื้อสำเร็จ!", "กรุณาตรวจสอบการสั่งซื้อ");

      },
    );
  }

  Future<void> processUploadInsertData() async {
    String apisaveSlip = '${API().BASE_URL}/rattaphumwater/saveSlip.php';
    String nameSlip = 'slip${Random().nextInt(1000000)}.jpg';

    try {
      Map<String, dynamic> map = {};
      map['file'] =
      await MultipartFile.fromFile(file!.path, filename: nameSlip);
      FormData data = FormData.fromMap(map);
      await Dio().post(apisaveSlip, data: data).then((value) async {
        String imageSlip = '/rattaphumwater/Slip/$nameSlip';
        print('value == $value');
        DateTime dateTime = DateTime.now();
        // print(dateTime.toString());
        String slipDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? userId = preferences.getString('id');
        String? userName = preferences.getString('Name');
        String path =
            '${API()
            .BASE_URL}/rattaphumwater/addpayment.php?isAdd=true&slip_date_time=$slipDateTime&image_slip=$imageSlip&order_id=none&user_id=$userId&user_name=$userName&emp_id=none';
        await Dio().get(path).then((value) {
          print("upload success");
        });

      });
    } catch (e) {}
  }

  Container buildwarning() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.indigo,
          ),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      padding: EdgeInsets.all(15.0),
      width: 300,
      child: Text(
        '*หมายเหตุ  กรุณาตรวจสอบรายการสั่งซื้อในตะกร้าก่อนกดยืนยันการชำระเงิน',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
