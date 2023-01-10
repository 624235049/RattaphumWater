import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../../../configs/api.dart';
import '../../../../helper/sqlite_helper.dart';
import '../../../../model/cart_model.dart';
import '../../../../model/product_model.dart';
import '../../../../model/user_model.dart';
import '../../../../utils/dialog.dart';
import '../../../../utils/style.dart';



class SingListOrder extends StatefulWidget {
  const SingListOrder({Key? key}) : super(key: key);

  @override
  State<SingListOrder> createState() => _SingListOrderState();
}

class _SingListOrderState extends State<SingListOrder> {

  @override
  void initState() {
    super.initState();
    findlatlng();
    readDataAdmin();
    readSingProduct();
  }

  Position? userlocation;
  UserModel? userModel;
  bool loadStatus = true; // Process load JSON
  bool status = true; // Have Data
  int amount = 1;
  String? lat2, lng2, distanceString;
  double? lat1, lng1;
  List<ProductModel> productmodels = [];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Product Sing CateGory",
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
            // print('You click == $index');
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

  Future<Null> findlatlng() async {
    Position positon = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat1 = positon.latitude;
      lng1 = positon.longitude;
      print("$lat1 , $lng1");
    });
  }


  Future<Null> readDataAdmin() async {

    String url = '${API().BASE_URL}/rattaphumwater/getUserWhereTypeadmin.php?isAdd=true&ChooseType=Admin';

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);

      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
          lat2 = userModel!.lat;
          lng2 = userModel!.lng;
        });
        print(" useradmin ===> ${userModel!.id}");
      }
    });
  }

  Future<Null> addOrderToCart(int index) async {
    String water_id = productmodels[index].waterId!;
    String brand_water = productmodels[index].brandName!;
    String price = productmodels[index].price!;
    String size = productmodels[index].size!;
    int priceInt = int.parse(price);
    int sumInt = priceInt * amount;
    double lat2M = double.parse(lat2!);
    double lng2M = double.parse(lng2!);
    double? distance = API().calculate2Distance(lat1!, lng1!, lat2M, lng2M);

    var myFormat = NumberFormat('##0.0#', 'en_US');
    distanceString = myFormat.format(distance);

    int? transport = API().calculateTransport(distance!);

    print(
      'water == $water_id, brand_water $brand_water , price == $price amount == $amount, sum == $sumInt, distance == $distanceString, transport == $transport ',
    );

    Map<String, dynamic> map = Map();
    map['water_id'] = water_id;
    map['brand_water'] = brand_water;
    map['price'] = price;
    map['size'] = size;
    map['amount'] = amount.toString();
    map['sum'] = sumInt.toString();
    map['distance'] = distanceString;
    map['transport'] = transport.toString();

    print('map ==> ${map.toString()}');
    CartModel cartModel = CartModel.fromJson(map);

    var object = await SQLiteHelper().readAllDataFormSQLite();
    print('object lenght == ${object.length}');

    if (object.length == 0) {
      await SQLiteHelper().insertDataToSQLite(cartModel).then((value) => {
        print('insert Sucess'),
      });
    } else {
      String brandSQLite = object[0].brand_water!;
      if (brandSQLite.isNotEmpty) {
        await SQLiteHelper().insertDataToSQLite(cartModel).then((value) => {
          print('insert Sucess'),

        });
      } else {
        normalDialog(context, 'รายการสั่งซื้อผิดพลาด !');
      }
    }
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

                          addOrderToCart(index);

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


  Future<Null> readSingProduct() async {
    if (productmodels.length != 0) {
      productmodels.clear();
    }

    String url = '${API().BASE_URL}/rattaphumwater/getproduct_sing.php?isAdd=true';
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
