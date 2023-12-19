import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seeya_hackthon_a/_common/geolocator/custom_geolocator.dart';
import 'package:seeya_hackthon_a/event/model/event_model.dart';

class CustomGoogleMaps extends StatefulWidget {
  final EventModel? eventState;

  const CustomGoogleMaps({this.eventState, super.key});

  @override
  State<CustomGoogleMaps> createState() => _CustomGoogleMapsState();

}

class _CustomGoogleMapsState extends State<CustomGoogleMaps> {
  GoogleMapController? _controller;
  late String eventId;
  late double latitudeState;
  late double longitudeState;


  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    latitudeState = widget.eventState?.latitude ?? 37.32512;
    longitudeState = widget.eventState?.longitude ?? 127.9887;
    eventId = widget.eventState?.eventId ?? "1";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
              target: LatLng(latitudeState, longitudeState),
              zoom: 17
          ),
          markers: <Marker>{Marker(markerId: MarkerId(eventId), position: LatLng(latitudeState, longitudeState))},
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
                  latitudeState = position.latitude;
                  longitudeState = position.longitude;
                });

                await _controller?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(latitudeState, longitudeState),
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
