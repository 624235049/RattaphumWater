import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../configs/api.dart';
import '../../../../../model/product_model.dart';
import '../../../../../utils/style.dart';

class NestleProduct extends StatefulWidget {
  const NestleProduct({Key? key}) : super(key: key);

  @override
  State<NestleProduct> createState() => _NestleProductState();
}

class _NestleProductState extends State<NestleProduct> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readWaterProduct();
  }


  bool loadStatus = true; // Process load JSON
  bool status = true; // Have Data

  List<ProductModel> productmodels = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Nestle Product",
          style: TextStyle(color: Colors.indigo),
        ),
        iconTheme: IconThemeData(color: Colors.indigo),
      ),
      body: loadStatus ? Style().showProgress()  :  showListProduct(),
    );
  }



  Widget showListProduct() => ListView.builder(
    itemCount: productmodels.length,
    itemBuilder: (context, index) => Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.4,
          child: productmodels.length == 0
              ? Style().showProgress()
              : Image.network(
              '${API().BASE_URL}${productmodels[index].waterImage}'),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.4,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'ยี่ห้อ: ${productmodels[index].brandName}',
                  style: Style().mainhATitle,
                ),
                Text(
                  'ขนาด : ${productmodels[index].size!} ML',
                  style: Style().mainh2Title,
                ),
                Text(
                  'ราคา : ${productmodels[index].price} บาท',
                  style: Style().mainh2Title,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        // MaterialPageRoute route = MaterialPageRoute(
                        //   builder: (context) => EditGasMenu(
                        //     gasModel: gasmodels[index],
                        //   ),
                        // );
                        // Navigator.push(context, route).then(
                        //       (value) => readGasMenu(),
                        // );
                      },
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () => deleteProduct(productmodels[index]),),

                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Future<Null> deleteProduct(ProductModel productModels) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Style().showTitleH2T(
            'คุณต้องการลบ รายการแก๊ส ${productModels.waterId} ใช่ไหม ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                  String url =
                      '${API().BASE_URL}/rattaphumwater/deleteWaterWhereid.php?isAdd=true&water_id=${productModels.waterId}';
                  await Dio().get(url).then((value) {
                    readWaterProduct();
                  });
                },
                color: Colors.green,
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                color: Colors.red,
              ),
            ],
          )
        ],
      ),
    );
  }



  Future<Null> readWaterProduct() async {
    if (productmodels.length != 0) {
      productmodels.clear();
    }


    String url = '${API().BASE_URL}/rattaphumwater/getproduct_nestle.php?isAdd=true';
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
