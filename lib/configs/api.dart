


import 'dart:math';

class API {
  String BASE_URL = 'https://4011-183-88-76-63.ap.ngrok.io';
  String keyId = 'id';
  String google_api_key = "AIzaSyA4eILUWwVSWooVRlC2AYhXsB3YOtkETDw";
  String keyType = 'ChooseType';
  String keyName = 'Name';



  int? calculateTransport(double distance) {
    int transport;
    if (distance < 1.0) {
      transport = 35;
      return transport;
    } else {
      transport = 35 + (distance - 1).round() * 10;
      return transport;
    }
  }
  double? calculate2Distance(
      double lat1, double lng1, double lat2, double lng2) {
    try {
      double distance = 0;
      var p = 0.017453292519943295; // Math.PI / 180
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
      distance = 12742 * asin(sqrt(a));

      return distance;
    } catch (e) {}
  }


}