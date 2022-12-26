import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rattaphumwater/pages/admin/screen/CRUD/CRUD_CS/edit_account.dart';

import '../../../../../configs/api.dart';
import '../../../../../configs/app_route.dart';
import '../../../../../model/user_model.dart';
import '../../../../../utils/style.dart';
import '../../../widget/app_icon.dart';
import '../../../widget/big_text.dart';
import 'edit_account.dart';

class ShowAccount extends StatefulWidget {
  const ShowAccount({Key? key}) : super(key: key);

  @override
  State<ShowAccount> createState() => _ShowAccountState();
}

class _ShowAccountState extends State<ShowAccount> {
  bool loadStatus = true; // Process load JSON
  bool status = true; // Have Data

  List<UserModel> usermodels = [];

  @override
  void initState() {
    readAccount();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 100,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BigText(
                  text: "Show Account Widget",
                  color: Colors.white,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoute.add_accountemp);
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
                  text: "Account Employee",
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
            // flexibleSpace: FlexibleSpaceBar(
            //   background: Image.network(
            //     AppConstants.BASE_URL + AppConstants.UPLOAD_URL + product.img!,
            //     width: double.maxFinite,
            //     fit: BoxFit.cover,
            //   ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  loadStatus ? Style().showProgress()  :  showListAccount(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget showListAccount() => ListView.builder(
    shrinkWrap: true,
    physics: ScrollPhysics(),
    itemCount: usermodels.length,
    itemBuilder: (context, index) => Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.5,
          child: usermodels[index].avatar == null
              ? Image.network(
              '${API().BASE_URL}${usermodels[index].avatar}')
              : buildNoneAvatarImage(),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.4,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'ID : ${usermodels[index].id} ',
                  style: Style().mainhPTitle,
                ),
                Text(
                  'สมาชิก : ${usermodels[index].chooseType} ',
                  style: Style().mainh2Title,
                ),
                Text(
                  'ชื่อ : ${usermodels[index].name} ',
                  style: Style().mainh2Title,
                ),
                Text(
                  'ติดต่อ : ${usermodels[index].phone} ',
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
                        MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => EditAccountEmp(
                            userModel: usermodels[index],
                          ),
                        );
                        Navigator.push(context, route).then(
                              (value) => readAccount(),
                        );

                      },
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () => deleteAccount(usermodels[index]),),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Future<Null> deleteAccount(UserModel userModels) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Style().showTitleH2T(
            'คุณต้องการลบ ข้อมูลสมาชิก User :${userModels.name} ใช่ไหม ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  print("${userModels.id}");
                  Navigator.pop(context);
                  String url =
                      '${API().BASE_URL}/rattaphumwater/deleteWaterWhereid.php?isAdd=true&id=${userModels.id}';
                  await Dio().get(url).then((value) {
                    readAccount();
                  });
                },
                color: Colors.green,
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                color: Colors.red,
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildNoneAvatarImage() {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/account.png'),
        ),
      ],
    );
  }





  Future<Null> readAccount() async {

    if (usermodels.length != 0) {
      usermodels.clear();
    }

    String url = '${API().BASE_URL}/rattaphumwater/readaccountEmp.php?isAdd=true&ChooseType=Employee';

    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      var result = json.decode(value.data);


      for (var item in result) {

        UserModel model = UserModel.fromJson(item);

        setState(() {
          usermodels.add(model);
        });
      }
    });
  }
}
