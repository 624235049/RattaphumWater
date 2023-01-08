import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../configs/api.dart';
import '../../../../model/product_model.dart';
import '../../../../utils/style.dart';


class NamthipListOrder extends StatefulWidget {
  const NamthipListOrder({Key? key}) : super(key: key);

  @override
  State<NamthipListOrder> createState() => _NamthipListOrderState();
}

class _NamthipListOrderState extends State<NamthipListOrder> {


  @override
  void initState() {
    super.initState();
    readProductNamthip();
  }

  List<ProductModel> productmodels = [];
  bool loadStatus = true; // Process load JSON
  bool status = true; // Have Data
  int amount = 1;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Product Namthip CateGory",
          style: TextStyle(color: Colors.indigo),
        ),
        iconTheme: IconThemeData(color: Colors.indigo),
      ),
      body: productmodels.length == 0
          ? Style().showProgress()
          : ListView.builder(
        itemCount: productmodels.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {

            amount = 1;
            confirmOrder(index);
          },
          child: Row(
            children: [
              showImageGas(context, index),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text(
                          'ขนาด ${productmodels[index].size} ml',
                          style: Style().mainTitle,
                        ),
                      ],
                    ),
                    Text('ราคา ${productmodels[index].price} บาท/แพ็ค',
                        style: Style().mainh2Title),
                    Text('รหัสสินค้า ${productmodels[index].waterId}',
                        style: Style().mainh2Title),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Container showImageGas(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      width: MediaQuery.of(context).size.width * 0.5 - 16.0,
      height: MediaQuery.of(context).size.width * 0.4,
      child: Image.network(
        '${API().BASE_URL}${productmodels[index].waterImage}',
        fit: BoxFit.cover,
      ),
    );
  }


  Future<Null> confirmOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'รหัส : ${productmodels[index].waterId} ',
                style: Style().mainh1Title,
              ),
              Text(
                'ขนาด ${productmodels[index].size} ml',
                style: Style().mainh1Title,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 200,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage(
                        '${API().BASE_URL}${productmodels[index].waterImage}'),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.blueAccent,
                        size: 36,
                      ),
                      onPressed: () {
                        setState(() {
                          amount++;
                        });
                      }),
                  Text(
                    amount.toString(),
                    style: Style().mainh1Title,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                      size: 36,
                    ),
                    onPressed: () {
                      if (amount > 1) {
                        setState(() {
                          amount--;
                        });
                      }
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 110,
                    child: RaisedButton(
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        // print(
                        //     'Order ${gasModels[index].gas_size_id} = $amount');

                        // if (nameUser != null) {
                        //   addOrderToCart(index);
                        // } else {
                        //   normalDialog(
                        //       context, 'กรุณาเข้าสู่ระบบก่อนสั่งซื้อขอบคุณค่ะ');
                        // }
                      },
                      child: Text(
                        'ใส่ตะกร้า',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: 110,
                    child: RaisedButton(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'ยกเลิก',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<Null> readProductNamthip() async{

    if (productmodels.length != 0) {
      productmodels.clear();
    }
    String url = '${API().BASE_URL}/rattaphumwater/getproduct_namthip.php?isAdd=true';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });
      if (value.toString() != 'null') {
        // print('value ==> $value');
        var result = json.decode(value.data);
        // print('result ==> $result');
        for (var map in result) {
          ProductModel productModel = ProductModel.fromJson(map);
          setState(() {
            productmodels.add(productModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });





  }
}
