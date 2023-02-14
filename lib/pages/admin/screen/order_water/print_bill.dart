import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../../configs/api.dart';
import '../../../../model/order_model.dart';
import '../../../../utils/style.dart';

class PrintBillWater extends StatefulWidget {
  const PrintBillWater({Key? key}) : super(key: key);

  @override
  State<PrintBillWater> createState() => _PrintBillWaterState();
}

class _PrintBillWaterState extends State<PrintBillWater> {
  bool loadStatus = true; // Process load JSON
  bool status = true;

  List<OrderModel> ordermodels = [];
  List<List<String>> listnameWater = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listPrices = [];
  List<List<String>> listSums = [];
  List<int> totals = [];
  List<List<String>> listusers = [];

  @override
  void initState() {
    findOrderShop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Print Bill Order",
          style: TextStyle(color: Colors.indigo),
        ),
        iconTheme: IconThemeData(color: Colors.indigo),
      ),
      body: ordermodels == null ? Style().showProgress() : showListOrderGas(),
    );
  }

  Widget showListOrderGas() {
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: ordermodels.length,
      itemBuilder: (context, index) => Card(
        color: index % 2 == 0 ? Colors.grey.shade100 : Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Style().showTitleH2(ordermodels[index].userName!),
                  IconButton(
                    onPressed: () async {
                      _createPDF(index);
                    },
                    icon: Icon(
                      Icons.print,
                      size: 30,
                    ),
                  ),
                ],
              ),
              Style().showTitleH2('คุณ ${ordermodels[index].userName}'),
              Style().showTitleH3('คำสั่งซื้อ : ${ordermodels[index].orderId}'),
              Style().showTitleH3(
                  'เวลาสั่งซื้อ :${ordermodels[index].orderDateTime}'),
              Style().showTitleH3(
                  'สถานะการชำระเงิน : ${ordermodels[index].paymentStatus}'),
              Style()
                  .showTitleH3('รหัสผู้จัดส่ง : ${ordermodels[index].empId}'),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createPDF(
      int index,
      ) async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    drawGrid(
        index, page, listAmounts, listnameWater, listPrices, listSums, totals);
    Imagebill(page, index, ordermodels);
    Detailbill(page, index, ordermodels);

    List<int> bytes = document.save() as List<int>;

    saveAndLanchFile(bytes, 'BillOrder${ordermodels[index].orderId}.pdf');
    document.dispose();
  }

  static void Imagebill(PdfPage page, int index, List<OrderModel> ordermodels) {
    page.graphics.drawString(
      'PPS GAS BILL order :${ordermodels[index].orderId}xxxxPPS',
      PdfStandardFont(PdfFontFamily.helvetica, 25),
    );
  }

  static void Detailbill(
      PdfPage page, int index, List<OrderModel> ordermodels) {
    page.graphics.drawString(
      'date order : ${ordermodels[index].orderDateTime}',
      PdfStandardFont(PdfFontFamily.helvetica, 25),
      bounds: const Rect.fromLTWH(0, 30, 0, 0),
    );
    page.graphics.drawString(
      'delivery distance : ${ordermodels[index].distance}kg.',
      PdfStandardFont(PdfFontFamily.helvetica, 25),
      bounds: const Rect.fromLTWH(0, 55, 0, 0),
    );
    page.graphics.drawString(
      'shipping cost : ${ordermodels[index].transport}THB.',
      PdfStandardFont(PdfFontFamily.helvetica, 25),
      bounds: const Rect.fromLTWH(0, 80, 0, 0),
    );
  }

  static void drawGrid(int index, PdfPage page, List listAmounts, listnameGas,
      listPrices, listSums, totals) {
    final grid = PdfGrid();
    grid.columns.add(count: 4);

    final headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Amount';
    headerRow.cells[1].value = 'Brand';
    headerRow.cells[2].value = 'Price';
    headerRow.cells[3].value = 'Total';
    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);

    final row = grid.rows.add();
    row.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
    if (listAmounts != null) {
      row.cells[0].value = '${listAmounts[index]}';
      row.cells[1].value = '${listnameGas[index]}';
      row.cells[2].value = '${listPrices[index]}';
      row.cells[3].value = '${totals[index]}';
    }

    for (var i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }

    grid.draw(page: page, bounds: Rect.fromLTWH(0, 110, 0, 0));
  }

  Future<void> saveAndLanchFile(List<int> bytes, String filename) async {
    final path = (await getExternalStorageDirectory())!.path;
    final file = File('$path/$filename');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$filename');
  }





  Future<Null> findOrderShop() async {
    if (ordermodels.length != 0) {
      ordermodels.clear();
    }

    String path =
        '${API().BASE_URL}/rattaphumwater/getOrderFinish.php?isAdd=true';
    await Dio().get(path).then((value) {
      // print('value ==> $value');
      var result = jsonDecode(value.data);
      // print('result ==> $result');
      if (result != null) {
        for (var item in result) {
          OrderModel model = OrderModel.fromJson(item);
          List<String> nameGas = API().createStringArray(model.brandWater!);
          List<String> amountgas = API().createStringArray(model.amount!);
          List<String> pricegas = API().createStringArray(model.price!);
          List<String> pricesums = API().createStringArray(model.sum!);
          List<String> user_id = API().createStringArray(model.userId!);

          int total = 0;
          for (var item in pricesums) {
            total = total + int.parse(item);
          }

          setState(() {
            loadStatus = false;
            ordermodels.add(model);
            listnameWater.add(nameGas);
            listAmounts.add(amountgas);
            listPrices.add(pricegas);
            listSums.add(pricesums);
            totals.add(total);
            listusers.add(user_id);
            loadStatus = false;
          });
        }
      } else {
        status = true;
      }
    });
  }
}
