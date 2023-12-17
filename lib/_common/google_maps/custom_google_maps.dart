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
  GoogleMapController? _controller;

  double latitude = 37.32512;
  double longitude = 127.9887;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 17
          ),
          markers: <Marker>{Marker(markerId: MarkerId("1"), position: LatLng(latitude, longitude))},
          onMapCreated: (controller) {
            _controller = controller;
            setState(() {
              isLoading = false;
            });
          },
        ),
        isLoading ? const Center(child: CircularProgressIndicator()) : Container(),
        Positioned(
          right: 0,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white
            ),
            child: IconButton(
              icon: const Icon(Icons.gps_fixed),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });

                Position position = await CustomGeolocator.getLocation();
                setState(() {
                  latitude = position.latitude;
                  longitude = position.longitude;
                });

                await _controller?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(latitude, longitude),
                      zoom: 17,
                      bearing: 0
                    ),
                  )
                );

                setState(() {
                  isLoading = false;
                });
              },
            ),
          )
        ),
      ],
    );
  }
}
