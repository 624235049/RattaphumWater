import 'package:flutter/material.dart';

import '../../../../configs/app_route.dart';
import '../../widget/app_icon.dart';
import '../../widget/big_text.dart';


class CateGory extends StatefulWidget {
  const CateGory({Key? key}) : super(key: key);

  @override
  State<CateGory> createState() => _CateGoryState();
}

class _CateGoryState extends State<CateGory> {
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
                  BigText(text: "Category Product", color: Colors.white,),
                  GestureDetector
                    (
                    onTap: () {
                      Navigator.pushNamed(context, AppRoute.add_product);
                    },

                    child: AppIcon(icon: Icons.add, iconSize: 24,),),
                ],
              ),

              bottom: PreferredSize(
                preferredSize: Size.fromHeight(20),
                child: Container(
                  child: Center(
                      child: BigText(
                        text: "Menu",
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
             child:  SingleChildScrollView(
               child: Column(
                 children: [

                   GestureDetector(
                     onTap: () {
                       Navigator.pushNamed(context, AppRoute.namthip_product);
                     },
                     child: Card(
                       semanticContainer: true,
                       clipBehavior: Clip.antiAliasWithSaveLayer,
                       child: Image.asset(
                         'assets/images/namthiplogo.png',
                         fit: BoxFit.fill,
                       ),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10.0),
                       ),
                       elevation: 5,
                       margin: EdgeInsets.all(10),
                     ),
                   ),

                   GestureDetector(
                     onTap: () {
                       Navigator.pushNamed(context, AppRoute.sing_product);
                     },
                     child: Card(
                       semanticContainer: true,
                       clipBehavior: Clip.antiAliasWithSaveLayer,
                       child: Image.asset(
                         'assets/images/singlogo.png',
                         fit: BoxFit.fill,
                       ),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10.0),
                       ),
                       elevation: 5,
                       margin: EdgeInsets.all(10),
                     ),
                   ),
                   GestureDetector(
                     onTap: () {
                       Navigator.pushNamed(context, AppRoute.crystal_product);
                     },
                     child: Card(
                       semanticContainer: true,
                       clipBehavior: Clip.antiAliasWithSaveLayer,
                       child: Image.asset(
                         'assets/images/crytstal.png',
                         fit: BoxFit.cover,
                       ),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10.0),
                       ),
                       elevation: 5,
                       margin: EdgeInsets.all(10),
                     ),
                   ),
                   GestureDetector(
                     onTap: () {
                       Navigator.pushNamed(context, AppRoute.nestle_product);
                     },
                     child: Card(
                       semanticContainer: true,
                       clipBehavior: Clip.antiAliasWithSaveLayer,
                       child: Image.asset(
                         'assets/images/nestlelogo.png',
                         fit: BoxFit.fill,
                       ),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10.0),
                       ),
                       elevation: 6,
                       margin: EdgeInsets.all(80),
                     ),
                   ),
                 ],
               ),

             ),
           )
          ],
        ),

    );

  }
}

