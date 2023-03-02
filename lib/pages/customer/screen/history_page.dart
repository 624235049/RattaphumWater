import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rattaphumwater/configs/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_indicator/steps_indicator.dart';

import '../../../model/order_model.dart';
import '../../../utils/dialog.dart';
import '../../../utils/style.dart';
import 'follow_delivery_map.dart';




class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}




class _HistoryPageState extends State<HistoryPage> {

  String? user_id;
  bool statusAvatar = true;
  bool loadStatus = true;
  List<OrderModel> orderModels = [];
  List<List<String>> listmenuGas = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listSums = [];
  List<int> totalInts = [];
  List<int> statusInts = [];
  List<List<String>> statusindexs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finduser();
  }


  @override
  Widget build(BuildContext context) {
    return statusAvatar ? Style().showProgress() : buildcontent();
  }

  Widget buildcontent() => ListView.builder(
    padding: EdgeInsets.all(20),
    itemCount: orderModels.length,
    itemBuilder: (context, index) => Column(
      children: [
        Style().mySizebox(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () async {
                if (orderModels[index].status == 'shopprocess') {
                  normalDialog2(context, 'ไม่สามารถยกเลิกการสั่งซื้อ',
                      'เนื่องจากร้านได้ยืนยันการสั่งซื้อของคุณแล้ว กรุณาติดต่อทางร้านค่ะ!');
                } else if (orderModels[index].status == 'RiderHandle') {
                  normalDialog2(context, 'ไม่สามารถยกเลิกการสั่งซื้อ',
                      'เนื่องจากกำลังจัดสั่งรายแก๊สให้คุณ กรุณาติดต่อทางร้านค่ะ!');
                } else if (orderModels[index].status == 'Finish') {
                  normalDialog2(context, 'รายการสั่งซื้อของท่านสำเร็จแล้ว!',
                      'กรุณาติดต่อทางร้านค่ะ');
                } else if (orderModels[index].status == 'userorder') {
                  confirmDeleteCancleOrder(index);
                }
              },
              child: Text(
                'ยกเลิกการสั่งซื้อ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (orderModels[index].status != 'Finish') {
                  if (orderModels[index].empId != 'none') {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => FollowTrackingDelivery(
                        orderModel: orderModels[index],
                      ),
                    );
                    Navigator.push(context, route).then((value) async {});
                  } else {
                    normalDialog(
                        context,
                        'รายการของท่านยังไม่ได้ทำการจัดส่ง'
                       );
                  }
                } else {
                  normalDialog(context, "รายการของท่านสำเร็จแล้ว");
                }
                print("${orderModels[index].empId}");
              },
              child: Text(
                'ติดตามการจัดส่ง',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        buildStepIndecator(statusInts[index]),
        Style().mySizebox(),
        buildheadtitle(),
        buildDatetimeOrder(index),
        buildtransport(index),
        builddistance(index),
        buildListviewMenuGas(index),
        Style().mySizebox(),
        buildTotal(index),
        Style().mySizebox(),
      ],
    ),
  );

  Future<Null> confirmDeleteCancleOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการจะยกเลิกรายการแก๊สใช่ไหม ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: Colors.green,
                onPressed: () async {
                  cancleOrderUser(index);
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                label: Text(
                  'ตกลง',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                label: Text(
                  'ยกเลิก',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }




  Future<Null> cancleOrderUser(int index) async {
    String order_id = orderModels[index].orderId!;
    String url =
        '${API().BASE_URL}/rattaphumwater/cancleOrderWhereorderId.php?isAdd=true&status=Cancle&order_id=$order_id';

    await Dio().get(url).then((value) {
      readOrder();
      normalDialog2(
          context, 'ยกเลิกรายการสั่งซื้อสำเร็จ', 'รายการสั่งซื้อที่ $order_id');
    });
  }

  Widget buildStepIndecator(int index) => Column(
    children: [
      StepsIndicator(
        lineLength: 80,
        selectedStep: index,
        nbSteps: 4,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('สั่งซื้อ'),
          Text('กำลังเตรียมแก๊ส'),
          Text('กำลังจัดส่ง'),
          Text('รายการสำเร็จ'),
        ],
      ),
    ],
  );

  Widget buildTotal(int index) => Row(
    children: [
      Expanded(
        flex: 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Style().showTitleH2('รวมทั้งสิ้น :'),
          ],
        ),
      ),

      //  MyStyle().showTitleHC(totalInts[index].toString()),
      Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            orderModels[index].status == 'Cancle'
                ? Style().showTitleHC('ยกเลิก')
                : Style()
                .showTitleHC('${totalInts[index].toString()} THB'),
          ],
        ),
      ),
    ],
  );

  ListView buildListviewMenuGas(int index) => ListView.builder(
    shrinkWrap: true,
    physics: ScrollPhysics(),
    itemCount: listmenuGas[index].length,
    itemBuilder: (context, index2) => Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(listmenuGas[index][index2]),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(listAmounts[index][index2]),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(listPrices[index][index2]),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(listSums[index][index2]),
            ],
          ),
        ),
      ],
    ),
  );

  Container buildheadtitle() {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Style().showTitleH2('รายการแก๊ส'),
          ),
          Expanded(
            flex: 1,
            child: Style().showTitleH2('จำนวน'),
          ),
          Expanded(
            flex: 1,
            child: Style().showTitleH2('ราคา'),
          ),
          Expanded(
            flex: 1,
            child: Style().showTitleH2('รวม'),
          )
        ],
      ),
    );
  }

  Text buildamount(int index) =>
      Style().showTitleH3('จำนวน ${orderModels[index].amount} ถัง');

  Text builddistance(int index) {
    return Style()
        .showTitleH3('ระยะทาง ${orderModels[index].distance} กิโลเมตร');
  }

  Row buildtransport(int index) {
    return Row(
      children: [
        Style().showTitleH3('ค่าจัดส่ง ${orderModels[index].transport} บาท'),
      ],
    );
  }

  Row buildDatetimeOrder(int index) {
    return Row(
      children: [
        Style().showTitleH3(
            'วันเวลาที่สั่งซื้อ ${orderModels[index].orderDateTime}'),
      ],
    );
  }

  Row buildNameShop(int index) {
    return Row(
      children: [
        Style().showTitleH3('ยี่ห้อ ${orderModels[index].brandWater}'),
      ],
    );
  }
  Future<Null> finduser() async {
    setState(() {
      loadStatus = false;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    user_id = preferences.getString('id');
    // print('user_id ==> $user_id');
    readOrder();
  }



  Future<Null> readOrder() async {

    String url = '${API().BASE_URL}/rattaphumwater/getOrderWhereuser_id.php?isAdd=true&user_id=$user_id';

    Response response = await Dio().get(url);
    // print('response ==> $response');
    if (response.toString() != 'null') {
      var result = jsonDecode(response.data);
      for (var map in result) {
        OrderModel model = OrderModel.fromJson(map);
        List<String> menuGas = changeArrey(model.waterId!);
        List<String> prices = changeArrey(model.price!);
        List<String> amounts = changeArrey(model.amount!);
        List<String> sums = changeArrey(model.sum!);

        int status = 0;
        switch (model.status) {
          case 'userorder':
            status = 0;
            break;
          case 'shopprocess':
            status = 1;
            break;
          case 'RiderHandle':
            status = 2;
            break;
          case 'Finish':
            status = 3;
            break;
          default:
        }
        // print('menuGas ==> $menuGas');
        int total = 0;
        for (var string in sums) {
          total = total + int.parse(string.trim());
        }
        print('total = $total');

        setState(() {
          statusAvatar = false;
          orderModels.add(model);
          listmenuGas.add(menuGas);
          listPrices.add(prices);
          listAmounts.add(amounts);
          listSums.add(sums);
          totalInts.add(total);
          statusInts.add(status);
          // updateorderId();
        });
      }
    }
  }

  List<String> changeArrey(String string) {
    List<String> list = [];
    String myString = string.substring(1, string.length - 1);
    print('myString = $myString');
    list = myString.split(',');
    int index = 0;
    for (var string in list) {
      list[index] = string.trim();
      index++;
    }
    return list;
  }
}
