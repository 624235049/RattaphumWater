import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:rattaphumwater/configs/app_route.dart';
import 'package:rattaphumwater/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';

import '../../../configs/api.dart';
import '../../../helper/sqlite_helper.dart';
import '../../../model/cart_model.dart';
import '../../../utils/dialog.dart';
import '../../../utils/style.dart';

class CartHistoryPage extends StatefulWidget {
  const CartHistoryPage({Key? key}) : super(key: key);

  @override
  State<CartHistoryPage> createState() => _CartHistoryPageState();
}

class _CartHistoryPageState extends State<CartHistoryPage> {
  List<CartModel> cartModels = [];
  List<List<String>> listgasids = [];
  List<int> listamounts = [];
  late ProductModel productModel;
  int total = 0;
  int quantityInt = 0;
  bool status = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    var object = await SQLiteHelper().readAllDataFormSQLite();
    print('object length ==> ${object.length}');
    int newTotal = 0; // สร้างตัวแปรใหม่เพื่อเก็บค่า total ที่ถูกคำนวณใหม่
    if (object.length != 0) {
      for (var model in object) {
        String? sumString = model.sum;
        int sumInt = int.parse(sumString!);
        newTotal += sumInt; // เพิ่มราคาสินค้าลงในตัวแปร newTotal
      }
    }
    setState(() {
      status = object.isEmpty; // ถ้า object ว่างเปล่าก็ให้ status เป็น true
      cartModels = object;
      total = newTotal; // กำหนดค่า total ให้เท่ากับ newTotal
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: status
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                child: SvgPicture.asset('assets/images/cart.svg'),
              ),
            )
          : buildcontents(),
    );
  }

  Widget buildcontents() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildmaintitleshop(),
            Divider(
              color: Colors.black26,
              height: 30,
              thickness: 5,
            ),
            buildheadtitle(),
            buildlistWater(),
            Divider(
              height: 50,
              thickness: 10,
            ),
            buildTotal(),
            Style().mySizebox(),
            buildAddOrderButton(),
            buildPaymentButton(),
          ],
        ),
      ),
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
        '${API().BASE_URL}/rattaphumwater/addOrder.php?isAdd=true&order_date_time=$order_date_time&user_id=$user_id&user_name=$user_name&water_id=$water_id&size=$size&distance=$distance&transport=$transport&brand_water=$brand_water&price=$price&amount=$amount&sum=$sum&emp_id=none&payment_status=payondelivery&status=userorder';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        // updateQtyGas(amount, gas_id);
        clearOrderSQLite();

        // notificationtoShop(user_name);
      } else {
        normalDialog(context, 'ไม่สามารถสั่งซื้อได้กรุณาลองใหม่');
      }
    });
  }

  Widget buildTotal() => Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Style().showTitleH2('ยอดรวมทั้งสิ้น = '),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Style().showTitleHC('${total.toString()} THB'),
          ),
        ],
      );

  Widget buildmaintitleshop() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16, left: 16),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Style().showTitle('รายการในตะกร้า'),
            ],
          ),
          Style().mySizebox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Style()
                  .showTitleH3('ระยะทาง : ${cartModels[0].distance} กิโลเมตร'),
              Style().showTitleH3('ค่าจัดส่ง : ${cartModels[0].transport} บาท'),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     MyStyle().showTitleH3('ค่าจัดส่ง ${cartModels[0].transport}'),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget buildheadtitle() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Style().showTitleH2('จำนวน'),
          ),
          Expanded(
            flex: 1,
            child: Style().showTitleH2('ยี่ห้อ'),
          ),
          Expanded(
            flex: 1,
            child: Style().showTitleH2('ขนาด'),
          ),
          Expanded(
            flex: 1,
            child: Style().showTitleH2('รวม'),
          ),
        ],
      ),
    );
  }


  Widget buildPaymentButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10, right: 10),
          width: 160,
          child: RaisedButton.icon(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: Colors.blueAccent,
            onPressed: () {
              // MaterialPageRoute route = MaterialPageRoute(
              //   builder: (context) => null,
              // );
              Navigator.pushNamed(context, AppRoute.confirmpayment).then((value) => readSQLite());
            },
            label: Text(
              'ชำระเงินล่วงหน้า',
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.add_shopping_cart_sharp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAddOrderButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10, right: 10),
          width: 160,
          child: RaisedButton.icon(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.indigoAccent,
            onPressed: () {
              orderThread();
            },
            label: Text(
              'สั่งซื้อปลายทาง',
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.add_shopping_cart_sharp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> clearOrderSQLite() async {
    await SQLiteHelper().deleteAllData().then(
      (value) {
        normalDialog2(context, "สั่งซื้อสำเร็จ", "รอรับสินค้าตรวจสอบการสั่งซื้อ");
        readSQLite();

      },
    );
  }

  Widget buildlistWater() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: cartModels.length,
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 10, bottom: 20),
            padding: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(
                    '${cartModels[index].amount}x',
                    style: Style().mainhATitle,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    cartModels[index].brand_water!,
                    style: Style().mainh23Title,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'ฺ${cartModels[index].size} kg.',
                    style: Style().mainh23Title,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ' ${cartModels[index].sum}ฺ THB',
                    style: Style().mainh23Title,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    color: Colors.red,
                    icon: Icon(Icons.delete_forever),
                    onPressed: () async {
                      int id = cartModels[index].id!;
                      int price = int.parse(cartModels[index].price!); // ราคาของสินค้าที่จะลบ
                      print('You Click delete id = $id');
                      await SQLiteHelper().deleteDataWhereId(id).then(
                            (value) {
                          print('delete Success id =$id');
                          setState(() {
                            total -= price; // ลบราคาสินค้าที่ถูกลบออกจากค่า total
                          });
                          readSQLite();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
}
