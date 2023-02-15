import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rattaphumwater/pages/employee/home_emp/screen/crud_order/edit_order.dart';
import 'package:rattaphumwater/pages/employee/home_emp/screen/map_follow/follow_map_customer.dart';
import '../../../configs/api.dart';
import '../../../configs/app_route.dart';
import '../../../model/order_model.dart';
import '../../../utils/dialog.dart';
import '../../../utils/logout.dart';
import '../../../utils/style.dart';
import '../../admin/widget/app_icon.dart';
import '../../admin/widget/big_text.dart';

class HomeEmp extends StatefulWidget {
  const HomeEmp({Key? key}) : super(key: key);

  @override
  State<HomeEmp> createState() => _HomeEmpState();
}

class _HomeEmpState extends State<HomeEmp> {
  List<OrderModel> orderModels = [];
  List<List<String>> listnameWater = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listPrices = [];
  List<List<String>> listSums = [];
  List<int> totals = [];
  List<List<String>> listusers = [];


  @override
  void initState() {
    readOrderProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Employee Page",
          style: TextStyle(color: Colors.indigo),
        ),
        iconTheme: IconThemeData(color: Colors.indigo),
        actions: [
          IconButton(
            icon: Icon(
              Icons.cancel,
              color: Colors.indigo,
              size: 32,
            ),
            onPressed: () => signOutProcess(context),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 100,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {

                  },
                  child: AppIcon(
                    icon: Icons.fact_check,
                    iconSize: 24,
                  ),
                ),
                BigText(
                  text: "Order Water CateGory",
                  color: Colors.white,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoute.addorder_emp);
                  },
                  child: AppIcon(
                    icon: Icons.add,
                    iconSize: 24,
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Container(
                child: Center(
                    child: BigText(
                  text: "Order Employee",
                  size: 26,
                )),
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
            pinned: true,
            backgroundColor: Colors.blueAccent,
            expandedHeight: 140,
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  orderModels == null
                      ? Style().showProgress()
                      : showListOrderGas()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget showListOrderGas() {
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: orderModels.length,
      itemBuilder: (context, index) => Card(
        color: index % 2 == 0 ? Colors.grey.shade100 : Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Style().showTitleH2('คุณ ${orderModels[index].userName}'),
              Style().showTitleH3('คำสั่งซื้อ : ${orderModels[index].orderId}'),
              Style().showTitleH3(
                  'เวลาสั่งซื้อ :${orderModels[index].orderDateTime}'),
              Style().showTitleH3(
                  'สถานะการชำระเงิน : ${orderModels[index].paymentStatus}'),
              Style()
                  .showTitleH3('รหัสผู้จัดส่ง : ${orderModels[index].empId}'),
              Style().showTitleH3('สถานะการจัดส่ง : รอการยืนยัน'),
              ListView.builder(
                itemCount: listnameWater[index].length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index2) => Container(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${listAmounts[index][index2]}x',
                          style: Style().mainh3Title,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          listnameWater[index][index2],
                          style: Style().mainh3Title,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          listPrices[index][index2],
                          style: Style().mainh3Title,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          listSums[index][index2],
                          style: Style().mainh3Title,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'รวมทั้งหมด :  ',
                            style: Style().mainh1Title,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${totals[index].toString()} THB',
                        style: Style().mainhATitle,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => EditOrderEmp(
                          orderModel: orderModels[index],
                        ),
                      );
                      Navigator.push(context, route).then(
                            (value) => readOrderProduct(),
                      );
                    },
                    child: Text("แก้ไข"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      cancleOrderUser(index).then((value) => readOrderProduct());
                    },
                    child: Text("ลบ"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: () {
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => FollowMapCustomer(
                          orderModel: orderModels[index],
                        ),
                      );
                      Navigator.push(context, route);
                    },

                    child: Icon(Icons.navigation),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> cancleOrderUser(int index) async {
    String? order_id = orderModels[index].orderId;
    String url =
        '${API().BASE_URL}/rattaphumwater/cancleOrderWhereorderId.php?isAdd=true&status=Cancle&order_id=$order_id';

    await Dio().get(url).then((value) {
      normalDialog2(
          context, 'ยกเลิกรายการสั่งซื้อสำเร็จ', 'รายการสั่งซื้อที่ $order_id');
    });
  }

  Future<Null> readOrderProduct() async {
    if (orderModels.length != 0) {
      orderModels.clear();
    }
    String path =
        "${API().BASE_URL}/rattaphumwater/getOrderwherestatus_Rider.php?isAdd=true";

    await Dio().get(path).then((value) {
      // print('value ==> $value');
      var result = jsonDecode(value.data);
      // print('result ==> $result');

      if (result != null) {
        for (var item in result) {
          OrderModel model = OrderModel.fromJson(item);
          List<String> nameGas = API().createStringArray(model.empId!);
          List<String> amountgas = API().createStringArray(model.amount!);
          List<String> pricegas = API().createStringArray(model.price!);
          List<String> pricesums = API().createStringArray(model.sum!);
          List<String> user_id = API().createStringArray(model.userId!);

          int total = 0;
          for (var item in pricesums) {
            total = total + int.parse(item);
          }
          setState(() {
            orderModels.add(model);
            listnameWater.add(nameGas);
            listAmounts.add(amountgas);
            listPrices.add(pricegas);
            listSums.add(pricesums);
            totals.add(total);
            listusers.add(user_id);
          });
        }
      }
    });
  }
}
