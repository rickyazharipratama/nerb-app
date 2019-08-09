import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/Views/Components/Collections/Items/DetailPlace.dart';
import 'package:nerb/Views/Components/Collections/MapPlaces.dart';
import 'package:nerb/Views/Components/misc/NerbPushAppBar.dart';

class Places extends StatefulWidget {

  final String title;
  final List<DetailNearbyPlaceResponse> places;
  final String nextToken;

  Places({@required this.title, this.places, this.nextToken});

  @override
  _PlacesState createState() => new _PlacesState();
}

class _PlacesState extends State<Places> {

  List<DetailNearbyPlaceResponse>places;
  String nextToken;
  Completer<GoogleMapController> mapController;

  CameraPosition plex;

  //0 list
  //1 grid
  //2
  int mode = 0;

  Set<Marker> mrk;
  LocationData myloc;

  @override
  void initState() {
    super.initState();
    mapController = Completer();
    if(widget.nextToken != null){
      this.nextToken = widget.nextToken;
    }
    if(widget.places != null){
      this.places = List();
      mrk = Set();
      widget.places.forEach((place){
        this.places.add(place);
        mrk.add(Marker(
          position: LatLng(double.parse(place.geometry.location.latitude), double.parse(place.geometry.location.longitude)),
          markerId: MarkerId(place.id),
          anchor: Offset(0.5,0),
          flat: true,
          infoWindow: InfoWindow(
            title: place.name
          ),
          visible: true,
        ));
      });
      this.places.addAll(widget.places);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          NerbPushAppBar(
            title: widget.title,
            buttom: Padding(
              padding: const EdgeInsets.only(top: 5, right: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  
                  GestureDetector(
                    onTap: (){
                      if(mode != 0){
                        if(mounted){
                          setState(() {
                            mode = 0;
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        color: mode == 0 ? Theme.of(context).buttonColor : Theme.of(context).highlightColor,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(5)
                        )
                      ),
                      child: Icon(
                        Icons.menu,
                        size: 20,
                        color: Theme.of(context).brightness == Brightness.light ? mode == 0 ? Colors.white : Theme.of(context).primaryTextTheme.body1.color : Theme.of(context).primaryTextTheme.body1.color,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      if(mode != 1){
                        if(mounted){
                          setState(() {
                            mode = 1;
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10,5,10,5),
                      decoration: BoxDecoration(
                        color: mode == 1 ? Theme.of(context).buttonColor : Theme.of(context).highlightColor,
                      ),
                      child: Icon(
                        Icons.view_module,
                        size: 20,
                        color: Theme.of(context).brightness == Brightness.light ? mode == 1 ? Colors.white : Theme.of(context).primaryTextTheme.body1.color : Theme.of(context).primaryTextTheme.body1.color,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () async{
                      if(mode != 2){
                        if(mounted){
                          Location loc = Location();
                          loc.changeSettings(
                            accuracy: LocationAccuracy.HIGH
                          );
                          try{
                            myloc = await loc.getLocation();
                            plex = CameraPosition(
                              target: LatLng(myloc.latitude, myloc.longitude),
                              zoom: 15.5,
                              bearing: 10,
                              tilt: 20
                            );
                          }on PlatformException catch(e){
                            print("error: "+e.code);
                          }
                          setState(() {
                            mode = 2;
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        color: mode == 2 ? Theme.of(context).buttonColor : Theme.of(context).highlightColor,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(5)
                        )
                      ),
                      child: Icon(
                        Icons.map,
                        size: 20,
                        color: Theme.of(context).brightness == Brightness.light ? mode == 2 ? Colors.white : Theme.of(context).primaryTextTheme.body1.color : Theme.of(context).primaryTextTheme.body1.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: mode == 0 ?
                ListView(
                  children: places.map((place){
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: DetailPlace(
                        place: place,
                      ),
                    );
                  }).toList(),
                )
              : mode == 1 ?
                GridView.count(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  childAspectRatio: 9/16,
                  children: places.map((place){
                    return DetailPlace(
                      place: place,
                      mode: 1,
                    );
                  }).toList(),
                )
              : mode == 2 ?
                MapPlaces(
                  markers: mrk,
                  myLocation: LatLng(myloc.latitude, myloc.longitude),
                  places: places,
                )
                : Container(),
          )
        ],
      ),
    ); 
  }

  @override
  void dispose() {
    super.dispose();
  }
}