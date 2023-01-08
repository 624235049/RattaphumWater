import 'package:flutter/material.dart';
import 'package:rattaphumwater/configs/app_route.dart';

class MainWaterPage extends StatefulWidget {
  const MainWaterPage({Key? key}) : super(key: key);

  @override
  State<MainWaterPage> createState() => _MainWaterPageState();
}

class _MainWaterPageState extends State<MainWaterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoute.namthiplistorder);
                      },
                      child: Container(
                          width: 200,
                          height: 200,
                          child: Image.asset('assets/images/namthiplogo.png')),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoute.singlistorder);
                      },
                      child: Container(
                          width: 200,
                          height: 200,
                          child: Image.asset('assets/images/singlogo.png')),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoute.crystallistorder);
                      },
                      child: Container(
                          width: 300,
                          height: 200,
                          child: Image.asset('assets/images/crytstal.png')),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoute.netlelistorder);
                      },
                      child: Container(
                          width: 150,
                          height: 200,
                          child: Image.asset('assets/images/nestlelogo.png')),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
