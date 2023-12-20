import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class CustomGeolocator {
  // 위치정보 권한 확인 -> 권한 거절 상태 시 재요청 -> 그래도 거절하면 로직 처리
  static Future<bool> requestGeolocatorPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {

        return false;
      }
    }

    Position position = await Geolocator.getCurrentPosition();

    return true;
  }

  static Future<Position> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
        msg: "위치정보 권한이 필요합니다.\n앱 설정에서 권한을 승인해주세요.",
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white,
      );

      return Future.error("권한 미승인");
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
  }

  static void getLocationUpdates() {
    final geolocator = GeolocatorPlatform.instance;

    geolocator.getPositionStream().listen((Position position) {
      // 위치가 변경될 때마다 호출되는 함수
      print('위치 변경: ${position.latitude}, ${position.longitude}');
    });
  }



}