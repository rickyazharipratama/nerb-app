import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nerb/Callbacks/RequestResponseCallback.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Controllers/PlaceController.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/Models/Response/SpecificDetailPlaceResponse.dart';
import 'package:nerb/Views/Components/Images/ImagePlaceholder.dart';
import 'package:nerb/Views/Components/misc/BottomDetailPlaces.dart';

class DetailPlaces extends StatefulWidget {
  final DetailNearbyPlaceResponse place;
  final String img;

  DetailPlaces({@required this.place , this.img});
  @override
  _DetailPlacesState createState() => new _DetailPlacesState();
}

class _DetailPlacesState extends State<DetailPlaces> with TickerProviderStateMixin implements RequestResponseCallback{


  AnimationController animController;
  Animation anim;
  double offset = 0;
  double currentOffsetPercent = 0;
  bool isdetailExpand = false;
  String img;
 
  int viewState = 1;
  int  statusCoe = 500;
  bool isAlreadyReqeust = false;
  SpecificDetailPlaceResponse detailPlace;

  @override
  void initState() {
    super.initState();
    print("src image : " + widget.img);
    if(widget.img == null){
      img = CommonHelper.instance.getPlaceImageByCategory(category: widget.place.category.id);
      if(img == null){
        if(widget.place.category.title.contains("/")){
          List<String> plcs = widget.place.category.title.split("/");
          for(int i= 0; i < plcs.length; i++){
            img = CommonHelper.instance.getPlaceImageByCategory(category: plcs[i].toLowerCase());
            if(img != null){
              i = plcs.length;
            }
          }
        }else{
          img = CommonHelper.instance.getPlaceImageByCategory(category: widget.place.category.title.toLowerCase());
        }
      }
    }else{
      img = widget.img;
    }
    initiateData();
    if(mounted){
      setState(() {
      });
    }
  }

  initiateData(){
    PlaceController.instance.getNearbyPlaceByNext(
      callback: this,
      language: "en",
      next: widget.place.href
    );
  }

  animateExplorer(isOpen){
    print("operating : "+ isOpen.toString());
    print("initial offset : "+offset.toString());
    animController = AnimationController(
      vsync: this, 
      duration: Duration(milliseconds: 1+(500 *(isdetailExpand ? currentOffsetPercent : (1 - currentOffsetPercent))).toInt()),
    );
    if(anim != null){
      anim = null;
    }
    anim = Tween<double>(begin: offset, end: isOpen ? (MediaQuery.of(context).size.height - 100) - 35 : 0).animate(CurvedAnimation(
      curve: Curves.ease,
      parent: animController
    ))..addStatusListener((status){
      if(status == AnimationStatus.completed){
        print("anim Completed");
        isdetailExpand = isOpen;
      }
    })..addListener((){
      if(mounted){
        setState(() {
          offset = anim.value;
          currentOffsetPercent =  max(0 , min(1,offset/((MediaQuery.of(context).size.height - 100) - 35)));
          print(offset);
          print(currentOffsetPercent);
        });
      }
    });
    animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async{
          if(isdetailExpand){
            animateExplorer(false);
          }else{
            Navigator.of(context).pop();
          }
          return true;
        },
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child : GestureDetector(
                onTap: (){
                  if(isdetailExpand){
                    animateExplorer(false);
                  }
                },
                child: Hero(
                  tag: "detailImage-"+widget.place.id,
                  child: img != null ?
                  Image.asset(
                    img,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    color: ColorCollections.wrapperCategory,
                    colorBlendMode: BlendMode.srcATop,
                  ) : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Theme.of(context).highlightColor,
                    child: ImagePlaceholder(),
                  ),
                ),
              )
            ),

            Positioned(
              bottom: 60,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Text(
                      widget.place.title,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      widget.place.vicinity.replaceAll("<br/>", "\n"),
                      style: Theme.of(context).textTheme.body2,
                    ),
                  )
                ],
              )
            ),


            Positioned(
              top: MediaQuery.of(context).padding.top + 5,
              right: 10,
              child: InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.circular(20),
                splashColor: ColorCollections.shimmerBaseColor,
                highlightColor: ColorCollections.shimmerHighlightColor,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle
                  ),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              child: BottomDetailPlaces(
                place: widget.place,
                animate: animateExplorer,
                currentOffsetPercent: currentOffsetPercent,
                isOpen: isdetailExpand,
                onVerticalDrugUpdate: (DragUpdateDetails details){
                  offset -= details.delta.dy;
                  if(offset > MediaQuery.of(context).size.height - 100){
                    offset = MediaQuery.of(context).size.height - 100;
                  }else if (offset < 0){
                    offset = 0;
                  }
                  if(mounted){
                    setState(() {
                      
                    });
                  }
                },
                panDown:() => animController?.stop(),
              ),
            ),

          ],
        ),
      )
    );
  }

  @override
  void dispose() {
    animController?.dispose();
    super.dispose();
  }

  @override
  onFailureWithResponse(Response res) {
     if(mounted){
       setState(() {
         isAlreadyReqeust = false;
         statusCoe = res.statusCode;
         viewState = 2;
       });
     }
  }

  @override
  onSuccessResponseFailed(Map<String,dynamic> data) {
    if(data['statusCode'] == ConstantCollections.STATUS_CODE_UNAUTHORIZE){
      if(!isAlreadyReqeust){
        Timer(const Duration(seconds: 2), (){
           // request back
           isAlreadyReqeust = true;
        });
      }else{
        if(mounted){
          setState(() {
            isAlreadyReqeust = false;
            viewState = 2;
            statusCoe = data['statusCode'];
          });
        }
      }
    }else{
      if(mounted){
        setState(() {
          isAlreadyReqeust = false;
          viewState = 2;
          statusCoe = data['statusCode'];
        });
      }
    }
  }

  @override
  onSuccessResponseSuccess(Map<String,dynamic> data) {
     detailPlace = SpecificDetailPlaceResponse.fromJson(data['result']);
     if(mounted){
       setState(() {
         viewState = 0;
         isAlreadyReqeust = false;
       });
     }
  }

  @override
  onfailure() {
    if(mounted){
      statusCoe = 500;
      viewState = 2;
      isAlreadyReqeust = false;
    }
  }
}