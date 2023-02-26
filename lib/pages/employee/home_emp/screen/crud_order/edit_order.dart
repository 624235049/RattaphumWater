import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rattaphumwater/configs/api.dart';
import 'package:rattaphumwater/model/order_model.dart';
import 'package:rattaphumwater/pages/admin/widget/big_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../utils/dialog.dart';
import '../../../../../utils/style.dart';

class EditOrderEmp extends StatefulWidget {
  final OrderModel orderModel;

  EditOrderEmp({Key? key, required this.orderModel}) : super(key: key);

  @override
  State<EditOrderEmp> createState() => _EditOrderEmpState();
}

class _EditOrderEmpState extends State<EditOrderEmp> {
  late OrderModel orderModel;
  File? file;
  String? brand_water,
      size,
      price,
      quantity,
      product_img,
      water_id,
      sum,
      distance,
      transport,
      order_id,
      status,
  statuspayment,
      username;
  String selectedValue = "userOrder";

  @override
  void initState() {
    super.initState();
    orderModel = widget.orderModel;
    brand_water = orderModel.brandWater;
    size = orderModel.size;
    price = orderModel.price;
    quantity = orderModel.amount;
    transport = orderModel.transport;
    distance = orderModel.distance;
    water_id = orderModel.waterId;
    order_id = orderModel.orderId;
    status = orderModel.status;
    username = orderModel.userName;
    statuspayment = orderModel.paymentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit ${brand_water} Order_id: ${orderModel.orderId}",
          style: TextStyle(color: Colors.indigo),
        ),
        iconTheme: const IconThemeData(color: Colors.indigo),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Style().mySizebox(),
            BigText(text: "สถานะจัดส่ง"),
            Container(
              width: 300,
              child: DropdownButtonFormField(
                value: status,
                items: dropdownItems,
                onChanged: (String? value) {
                  setState(() {
                    status = value!;
                  });
                },
              ),
            ),
            BigText(text: "สถานะการชำระเงิน"),
            Container(
              width: 300,
              child: DropdownButtonFormField(
                value: statuspayment,
                items: dropdownItemspay,
                onChanged: (String? value) {
                  setState(() {
                    statuspayment = value!;
                  });
                },
              ),
            ),
            disTanceWater(),
            usernameOrder(),
            transportWater(),
            saveButton(),
          ],
        ),
      ),
    );
  }

  Widget usernameOrder() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              onChanged: (value) => username = value.trim(),
              initialValue: username,
              decoration: InputDecoration(
                labelText: 'ชื่อผู้จดส่ง',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget disTanceWater() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              onChanged: (value) => distance = value.trim(),
              initialValue: distance,
              decoration: InputDecoration(
                labelText: 'ระยะทาง',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget transportWater() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              onChanged: (value) => transport = value.trim(),
              initialValue: transport,
              decoration: InputDecoration(
                labelText: 'ค่าจัดส่ง',
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
                icon: const Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                label: const Text(
                  'ตกลง',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: const Text(
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

  Future<Null> editproductMySQL() async {
    DateTime dateTime = DateTime.now();
    String order_date_time = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString('id');
    String? userName = preferences.getString('Name');
    String url =
        '${API().BASE_URL}/rattaphumwater/editOrder.php?isAdd=true&order_date_time=$order_date_time&user_id=$userId&user_name=$userName&water_id=$water_id&distance=$distance&transport=$transport&brand_water=$brand_water&size=$size&price=$price&amount=$quantity&sum=$sum&emp_id=$userId&payment_status=$statuspayment&status=$status&order_id=$order_id';
    await Dio().get(url).then(
      (value) {
        Navigator.pop(context);
        print('Edit Order Success');
      },
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("สั่งซื้อ"), value: "userorder"),
      DropdownMenuItem(child: Text("รับออเดอร์"), value: "shopprocess"),
      DropdownMenuItem(child: Text("กำลังจัดส่ง"), value: "RiderHandle"),
      DropdownMenuItem(child: Text("สำเร็จ"), value: "Finish"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItemspay {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("เก็บเงินปลายทาง"), value: "payondelivery"),
      DropdownMenuItem(
          child: Text("ชำระเงินล่วงหน้า"), value: "confirmpayment"),
    ];
    return menuItems;
  }
}
