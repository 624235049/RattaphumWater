import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rattaphumwater/model/user_model.dart';
import 'package:rattaphumwater/utils/style.dart';

import '../../../../../configs/api.dart';
import '../../../../../model/order_model.dart';
import '../../../../../utils/dialog.dart';




class FollowMapCustomer extends StatefulWidget {
  final OrderModel orderModel;
  const FollowMapCustomer({Key? key, required this.orderModel}) : super(key: key);

  @override
  State<FollowMapCustomer> createState() => _FollowMapCustomerState();
}

class _FollowMapCustomerState extends State<FollowMapCustomer> {
  late OrderModel orderModel;
  late UserModel userModel;
  String? user_id,username;

  double? lat1, lng1, lat2, lng2;
  CameraPosition? position;
  List<LatLng> polylineCoordinates = [];
  GoogleMapController? _controller;
  List<UserModel> userModels = [];

  @override
  void initState() {
    orderModel = widget.orderModel;
    user_id = orderModel.userId;
    FindUserWhererider();

    super.initState();
  }

  Future<Null> findlatlng() async {
    Position positon = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat1 = positon.latitude;
      lng1 = positon.longitude;
      lat2 = double.parse(userModel.lat!);
      lng2 = double.parse(userModel.lng!);
    });
  }

  Future<Null> FindUserWhererider() async {
    if (userModels.length != 0) {
      userModels.clear();
    }
    String url =
        '${API().BASE_URL}/rattaphumwater/getUserriderWhereId.php?isAdd=true&id=$user_id';

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      for (var item in result) {
        userModel = UserModel.fromJson(item);

      }
      findlatlng();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "ติดตามการจัดส่ง ",
          style: TextStyle(color: Colors.indigo),
        ),
        iconTheme: const IconThemeData(color: Colors.indigo),

      ),
      body: lat1 == null || lng2 == null ?  Style().showProgress() : showList(),
    );
  }

  Widget showList() => Column(
    children: [
      buildMap(),
      ListTile(
        leading: Icon(Icons.phone),
        title: Text('ติดต่อ : ${userModel.phone}'),
      ),
      ListTile(
        leading: Icon(Icons.phone),
        title: Text('ชื่อลูกค้า คุณ : ${userModel.name}'),
      ),
    ],
  );

  Container buildMap() {
    return Container(
      height: 500,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat2!, lng2!),
          zoom: 16,
        ),
        polylines: {
          Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Color.fromARGB(255, 15, 50, 80),
            width: 10,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: mySet(),
      ),
    );
  }



  Marker riderMarker() {
    return Marker(
      markerId: MarkerId('userOrderMarker'),
      position: LatLng(lat2!, lng2!),
      icon: BitmapDescriptor.defaultMarkerWithHue(150.0),
      infoWindow: InfoWindow(
          title: 'ลูกค้าอยู่ที่นี่ ', snippet: 'รหัสลูกค้า${userModel.id}'),
    );
  }

  Marker userMarker() {
    return Marker(
      markerId: MarkerId('userMarker'),
      position: LatLng(lat1!, lng1!),
      icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(
        title: 'คุณอยู่ที่นี่',
      ),
    );
  }

  Set<Marker> mySet() {
    return <Marker>[userMarker(), riderMarker()].toSet();
  }
}
