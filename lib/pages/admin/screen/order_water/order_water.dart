import 'package:flutter/material.dart';

import '../../../../configs/app_route.dart';
import '../../widget/app_icon.dart';
import '../../widget/big_text.dart';



class OrderWater extends StatefulWidget {
  const OrderWater({Key? key}) : super(key: key);

  @override
  State<OrderWater> createState() => _OrderWaterState();
}

class _OrderWaterState extends State<OrderWater> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 100,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                GestureDetector
                  (
                  onTap: () {
                    // Navigator.pushNamed(context, AppRoute.add_product);
                  },

                  child: AppIcon(icon: Icons.fact_check, iconSize: 24,),),
                BigText(text: "Order Water CateGory", color: Colors.white,),
                GestureDetector
                  (
                  onTap: () {
                    // Navigator.pushNamed(context, AppRoute.add_product);
                  },

                  child: AppIcon(icon: Icons.print, iconSize: 24,),),
              ],
            ),

            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Container(
                child: Center(
                    child: BigText(
                      text: "Order Water",
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
            child:  SingleChildScrollView(
              child: Column(
                children: [


                ],
              ),

            ),
          )
        ],
      ),

    );
  }
}
