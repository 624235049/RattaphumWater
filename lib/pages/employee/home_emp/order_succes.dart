import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rattaphumwater/pages/employee/home_emp/screen/crud_order/edit_order.dart';
import 'package:rattaphumwater/pages/employee/home_emp/screen/map_follow/follow_map_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../configs/api.dart';

import '../../../model/order_model.dart';
import '../../../utils/dialog.dart';
import '../../../utils/logout.dart';
import '../../../utils/style.dart';
import '../../admin/widget/app_icon.dart';
import '../../admin/widget/big_text.dart';

class OrderConfirmSuccessEmp extends StatefulWidget {
  const OrderConfirmSuccessEmp({Key? key}) : super(key: key);

  @override
  State<OrderConfirmSuccessEmp> createState() => _OrderConfirmSuccessEmpState();
}

class _OrderConfirmSuccessEmpState extends State<OrderConfirmSuccessEmp> {
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
        title: const Text(
          "Employee Page",
          style: TextStyle(color: Colors.indigo),
        ),
        iconTheme: IconThemeData(color: Colors.indigo),
        actions: [
          IconButton(
            icon: const Icon(
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
                // GestureDetector(
                //   onTap: () {
                //
                //   },
                //   child: AppIcon(
                //     icon: Icons.fact_check,
                //     iconSize: 24,
                //   ),
                // ),
                Center(
                  child: BigText(
                    text: "Successful Order Confirmation",
                    color: Colors.white,
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //
                //   },
                //   child: AppIcon(
                //     icon: Icons.add,
                //     iconSize: 24,
                //   ),
                // ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Container(
                child: Center(
                    child: BigText(
                      text: "CheckOut Order",
                      size: 20,
                    )),
                width: double.maxFinite,
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                decoration: const BoxDecoration(
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
              orderModels[index].status.toString() != 'RiderHandle'
                  ? Style().showTitleH3("สถานะการจัดส่ง : รอการยืนยัน")
                  : Style().showTitleH3("สถานะการจัดส่ง : กำลังจัดส่ง"),
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
                  // ElevatedButton(
                  //   onPressed: () {
                  //     MaterialPageRoute route = MaterialPageRoute(
                  //       builder: (context) => EditOrderEmp(
                  //         orderModel: orderModels[index],
                  //       ),
                  //     );
                  //     Navigator.push(context, route).then(
                  //           (value) => readOrderProduct(),
                  //     );
                  //   },
                  //   child: const Text("แก้ไข"),
                  // ),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     cancleOrderUser(index)
                  //         .then((value) => readOrderProduct());
                  //   },
                  //   child: Text("ลบ"),
                  // ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
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
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      updateStatusConfirmOrder(index).then((value) {
                        print("success update status riderhandle");
                      });
                    },
                    child: const Text(
                      "จัดส่งสำเร็จ",
                      style: TextStyle(fontWeight: FontWeight.bold),
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


  Future<Null> updateStatusConfirmOrder(int index) async {
    String user_id = orderModels[index].userId!;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? emp_id = preferences.getString('id');

    String path =
        '${API().BASE_URL}/rattaphumwater/editStatusWhereuser_id_RiderHandle.php?isAdd=true&status=Finish&emp_id=$emp_id&user_id=$user_id';

    await Dio().get(path).then(
          (value) {
        if (value.toString() == 'true') {
          normalDialog2(context, "จัดส่งสำเร็จ", "อัพเดทสถานะจัดส่ง")
              .then((value) {
            setState(() {
              readOrderProduct();
            });
          });
        }
      },
    );
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
