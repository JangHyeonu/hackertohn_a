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

  final List<Marker> _markers = [];

  late String eventId;
  late String eventName;
  late double eventLatitudeState;
  late double eventLongitudeState;

  double? myLatitudeState;
  double? myLongitudeState;

  bool isLoading = false;
  bool isActivatedGps = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 행사 마커 변수 초기화
    eventId = widget.eventState?.eventId ?? "1";
    eventName = widget.eventState?.businessName ?? "행사 장소";
    eventLatitudeState = widget.eventState?.latitude ?? 37.32512;
    eventLongitudeState = widget.eventState?.longitude ?? 127.9887;

    // 행사 마커 등록
    _markers.add(Marker(
      markerId: MarkerId(eventId),
      position: LatLng(
        eventLatitudeState, eventLongitudeState
      ),
      infoWindow: InfoWindow(title: eventName),
    ));

    // setState(() {
    //   CustomGeolocator.getLocationUpdates();
    // });
  }

  @override
  Widget build(BuildContext context) {


    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(eventLatitudeState, eventLongitudeState),
            zoom: 18
          ),
          markers: Set.from(_markers),
          onMapCreated: (controller) {
            setState(() {
              _controller = controller;
              isLoading = false;
            });
          },
        ),
        isLoading ? const Center(child: CircularProgressIndicator()) : Container(),
        Positioned(
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: !isActivatedGps ? Colors.white : Colors.grey
            ),
            child: IconButton(
              icon: const Icon(Icons.gps_fixed),
              onPressed: () async {
                Position position = await CustomGeolocator.getLocation().catchError(() {
                  return null;
                });

                if(position.latitude == null || position.longitude == null) {
                  return;
                }

                setState(() {
                  isLoading = true;
                  isActivatedGps = !isActivatedGps;
                  myLatitudeState = position.latitude;
                  myLongitudeState = position.longitude;

                  if(_markers.length < 2) {
                    _markers.add(Marker(
                      markerId: const MarkerId("myEventId"),
                      position: LatLng(
                          myLatitudeState!, myLongitudeState!
                      ),
                      infoWindow: const InfoWindow(title: "내 위치")
                    ));
                  }
                });

                // GPS 버튼 클릭 & 활성화 여부에 따라 처리
                if(isActivatedGps) {
                  await _controller?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(myLatitudeState!, myLongitudeState!),
                        zoom: 17,
                        bearing: 0
                      ),
                    ),
                  );
                } else {
                  await _controller?.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(eventLatitudeState!, eventLongitudeState!),
                          zoom: 18,
                          bearing: 0
                        ),
                      )
                  );
                }


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
