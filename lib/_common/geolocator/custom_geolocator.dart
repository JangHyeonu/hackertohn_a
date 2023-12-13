import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CustomGeolocator {

  // 위치정보 권한 확인 -> 권한 거절 상태 시 재요청 -> 그래도 거절하면 로직 처리
  static Future<bool> requestGeolocatorPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // 위치 권한이 거부되었습니다. 처리할 로직을 추가하세요.


        return false;
      }
    }

    Position position = await Geolocator.getCurrentPosition();

    return true;
  }


}