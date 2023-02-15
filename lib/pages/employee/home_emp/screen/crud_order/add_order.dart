import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../configs/api.dart';
import '../../../../../utils/dialog.dart';
import '../../../../admin/widget/app_text_field.dart';



class AddOrderEmp extends StatefulWidget {
  const AddOrderEmp({Key? key}) : super(key: key);

  @override
  State<AddOrderEmp> createState() => _AddOrderEmpState();
}

class _AddOrderEmpState extends State<AddOrderEmp> {
  File? file;

  String? brand_name;
  var sizecontroller = TextEditingController();
  var usernamecontroller = TextEditingController();
  var quantitycontroller = TextEditingController();
  var pricecontroller = TextEditingController();
  String selectedValue = "Sing";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "AddOrder Page",
          style: TextStyle(color: Colors.indigo),
        ),
        iconTheme: const IconThemeData(color: Colors.indigo),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30,),
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
                textController: usernamecontroller, hintText: "ชื่อ", icon: Icons.add),
            AppTextField(
                textController: sizecontroller, hintText: "ขนาด", icon: Icons.add),
            AppTextField(
                textController: quantitycontroller, hintText: "จำนวน", icon: Icons.add),
            AppTextField(
                textController: pricecontroller, hintText: "รวม", icon: Icons.add),
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
          orderThread();
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

  Future<Null> orderThread() async {
    var price = pricecontroller.text;
    var quantity = quantitycontroller.text;
    var size = sizecontroller.text;
    var sum = pricecontroller.text;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user_id = preferences.getString('id');
    String? user_name = preferences.getString('Name');
    DateTime dateTime = DateTime.now();
    // print(dateTime.toString());
    String order_date_time = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

    String url =
        '${API()
        .BASE_URL}/rattaphumwater/addOrder.php?isAdd=true&order_date_time=$order_date_time&user_id=$user_id&user_name=$user_name&water_id=none&size=[$size]&distance=0&transport=0&brand_water=[$brand_name]&price=$price&amount=[$quantity]&sum=[$sum]&emp_id=none&payment_status=payondelivery&status=userorder';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
        normalDialog(context, 'เพิ่มการสั่งซื้อสำเร็จ');

      } else {
        normalDialog(context, 'ไม่สามารถสั่งซื้อได้กรุณาลองใหม่');
      }
    });

  }



}
