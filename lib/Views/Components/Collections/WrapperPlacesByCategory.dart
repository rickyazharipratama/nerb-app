import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/PlaceModel.dart';
import 'package:nerb/Views/Components/Collections/Items/PlaceItem.dart';
import 'package:nerb/Views/Components/Shimmers/Items/ShimmerPlace.dart';
import 'package:nerb/Views/Components/misc/ErrorPlaceholder.dart';
import 'package:shimmer/shimmer.dart';

class WrapperPlacesBycategory extends StatefulWidget {

  final String category;

  WrapperPlacesBycategory({this.category});

  @override
  _WrapperPlacesBycategoryState createState() => new _WrapperPlacesBycategoryState();
}

class _WrapperPlacesBycategoryState extends State<WrapperPlacesBycategory> {

  // 0 main
  // 1 load
  // 2 error
  int viewState = 1;

  List<PlaceModel> places;

  @override
  void initState() {
    super.initState();
    initiateData();
  }

  @override
  Widget build(BuildContext context) {
    return viewState == 0 ?
      places.length > 0 ?
        Wrap(
          runSpacing: 15,
          spacing: 10,
          children: places.map((place){
            return PlaceItem(
              place: place,
            );
          }).toList(),
        )
      : ErrorPlaceholder(
          title: UserLanguage.of(context).errorTitle("typePlaceEmpty"),
          desc: UserLanguage.of(context).errorDesc("typePlaceEmpty"),
          isNeedButton: false,
      )
    : viewState == 2 ? ErrorPlaceholder(
      title: UserLanguage.of(context).errorTitle("general"),
      desc: UserLanguage.of(context).errorDesc("general"),
      buttonText: UserLanguage.of(context).button("retry"),
      callback: (){
        viewState = 1;
        initiateData();
      },
    ) : Shimmer.fromColors(
          baseColor: Theme.of(context).highlightColor,
          highlightColor: ColorCollections.shimmerHighlightColor,
          child : Wrap(
            runSpacing: 15,
            spacing: 10,
            children: [0,1,2,3,4,5].map((data){
              return ShimmerPlace();
            }).toList(),
          )
      );
  }

  initiateData() async{
    Firestore.instance.collection(ConstantCollections.FIRESTORE_PLACE)
      .where("categories", arrayContains: widget.category)
      .snapshots()
      .listen(retrievePlaces)
      .onError(onLoadError);
  }

  retrievePlaces(QuerySnapshot query){
    List<PlaceModel> tmp = List();
    for(DocumentSnapshot doc in query.documents){
      tmp.add(PlaceModel.fromFireStore(doc.documentID,doc.data));
    }
    if(places == null){
      places = List();
    }else{
      places.clear();
    }
    places.addAll(tmp);
    if(mounted){
      setState(() {
        viewState = 0;
      });
    }
  }


  onLoadError(error){
    if(mounted){
      setState(() {
        viewState = 2;
      });
    }
  }
}