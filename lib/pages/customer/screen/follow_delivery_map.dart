import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../configs/api.dart';
import '../../../model/order_model.dart';
import '../../../model/user_model.dart';
import '../../../utils/style.dart';

class FollowTrackingDelivery extends StatefulWidget {
  final OrderModel orderModel;

  FollowTrackingDelivery({Key? key, required this.orderModel})
      : super(key: key);

  @override
  State<FollowTrackingDelivery> createState() => _FollowTrackingDeliveryState();
}

class _FollowTrackingDeliveryState extends State<FollowTrackingDelivery> {
  OrderModel? orderModel;
  UserModel? userModel;
  String? order_id, date_time, emp_id;
  double? lat1, lng1, lat2, lng2;
  String? distanceString;
  int? transport;
  Position? userlocation;
  CameraPosition? position;
  List<LatLng> polylineCoordinates = [];
  GoogleMapController? _controller;
  List<UserModel> userModels = [];

  @override
  void initState() {
    super.initState();
    orderModel = widget.orderModel;
    emp_id = orderModel!.empId;
    order_id = orderModel!.orderId;
    date_time = orderModel!.orderDateTime;
    FindUserWhererider();
    findLatLng();
    getPolyPoints();
  }

  Future<Null> findLatLng() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat1 = position.latitude;
      lng1 = position.longitude;
      lat2 = double.parse(userModel!.lat.toString());
      lng2 = double.parse(userModel!.lng.toString());
    });
  }

  Future<Null> FindUserWhererider() async {
    if (userModels.length != 0) {
      userModels.clear();
    }
    String url =
        '${API().BASE_URL}/rattaphumwater/getUserriderWhereId.php?isAdd=true&id=$emp_id';

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      for (var item in result) {
        userModel = UserModel.fromJson(item);
      }
    });
  }

  Widget showNoData(BuildContext context) =>
      const Center(child: Text("ยังไม่มีข้อมูล"),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการสั่งซื้อที่ ${orderModel!.orderId}'),
      ),
      body: lat1 == null ? Style().showProgress() : showList(),
    );
  }

  // Future refresh() async {
  //   await Future.delayed(
  //     Duration(seconds: 3),
  //   );
  //   findLatLng();
  // }

  Widget showList() => Column(
        children: [
          buildMap(),
          ListTile(
            leading: userModel!.avatar == null
                ? Style().showProgress()
                : Container(
                    width: 50,
                    height: 50,
                    child: CachedNetworkImage(
                        imageUrl: '${API().BASE_URL}${userModel!.avatar}')),
            title: Text('ผู้จัดส่ง : ${userModel!.name}'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('ติดต่อ : ${userModel!.phone}'),
          ),
        ],
      );

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      API().google_api_key,
      PointLatLng(lat1!, lng1!),
      PointLatLng(lat2!, lng2!),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  Container buildMap() {
    return Container(
      height: 500,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat1!, lng1!),
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
      markerId: MarkerId('riderMarker'),
      position: LatLng(lat2!, lng2!),
      icon: BitmapDescriptor.defaultMarkerWithHue(150.0),
      infoWindow: InfoWindow(
          title: 'พนักงานอยู่ที่นี่ ', snippet: 'ชื่อพนักงาน${userModel!.name}'),
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
