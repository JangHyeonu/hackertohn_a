import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seeya_hackthon_a/_common/geolocator/custom_geolocator.dart';

class CustomGoogleMaps extends StatefulWidget {
  const CustomGoogleMaps({super.key});

  @override
  State<CustomGoogleMaps> createState() => _CustomGoogleMapsState();

}

class _CustomGoogleMapsState extends State<CustomGoogleMaps> {

  @override
  Widget build(BuildContext context) {

    return const GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(37.540853, 127.078971),
        zoom: 17
      ),

    );
  }
}
