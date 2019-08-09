import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/Views/Components/Collections/Items/DetailMapPlace.dart';
import 'package:nerb/Views/Components/misc/NerbGoogleMap.dart';

class MapPlaces extends StatefulWidget {
  final Set<Marker> markers;
  final List<DetailNearbyPlaceResponse> places;
  final LatLng myLocation;

  MapPlaces({@required this.markers, @required this.places, @required this.myLocation});

  @override
  _MapPlacesState createState() => new _MapPlacesState();
}

class _MapPlacesState extends State<MapPlaces> {

  DetailNearbyPlaceResponse activePlace;
  Completer<GoogleMapController> mapController = Completer();
  Set<Marker> markers;

  @override
  void initState() {
    super.initState();
    this.markers = widget.markers;
    if(markers == null){
      markers = Set();
      widget.places.forEach((place){
        markers.add(
          Marker(
            markerId: MarkerId(place.id),
            alpha: 0.6,
            infoWindow: InfoWindow(
              anchor: Offset(1,0),
              title: place.name
            ),
            position: LatLng(double.parse(place.geometry.location.latitude), double.parse(place.geometry.location.longitude)),
          )
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: NerbGoogleMap(
            markers: markers,
            myLocation: widget.myLocation,
            controller: mapController,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 10),
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: widget.places.map((place){
                return DetailMapPlace(
                  callback: onPlaceClcked,
                  place: place,
                  isActive: activePlace != null && activePlace.id == place.id,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  onPlaceClcked(DetailNearbyPlaceResponse place) async{
    markers.clear();
    widget.places.forEach((plc){
      markers.add(
        Marker(
          markerId: MarkerId(place.id),
          alpha: place.id == plc.id ? 1 : 0.6,
          infoWindow: InfoWindow(
            anchor: Offset(1,0),
            title: place.name
          ),
          position: LatLng(double.parse(place.geometry.location.latitude), double.parse(place.geometry.location.longitude)),
        )
      );
    });
    GoogleMapController ctr = await mapController.future;
    if(mounted){
      setState(() {
        activePlace = place;
        ctr.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(double.parse(place.geometry.location.latitude), double.parse(place.geometry.location.longitude)),
          zoom: 15.5
        )));
      });
    }
  }
}