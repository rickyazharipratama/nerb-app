import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NerbGoogleMap extends StatelessWidget {

  final Completer<GoogleMapController> controller;
  final Set<Marker> markers;
  final LatLng myLocation;
  NerbGoogleMap({@required this.controller, @required this.markers, @required this.myLocation});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: myLocation,
        zoom: 15.5,
      ),
      onMapCreated: (ctr){
        this.controller.complete(ctr);
      },
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      markers: markers,
    );
  }
}