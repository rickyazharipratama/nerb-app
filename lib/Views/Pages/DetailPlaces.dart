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
import 'package:nerb/Views/Components/misc/ErrorPlaceholder.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

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
          return false;
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

            viewState == 0 ?
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
                        detailPlace.name,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),

                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    detailPlace.location.address.text.replaceAll("<br/>", "\n"),
                                    maxLines: 4,
                                    style: Theme.of(context).textTheme.body2,
                                  ),
                                ),

                                detailPlace.extended != null ?
                                  detailPlace.extended.openingHours != null ?
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: detailPlace.extended.openingHours.isOpen ? Colors.green : Colors.grey
                                      ),
                                      child: Text(
                                          detailPlace.extended.openingHours.isOpen ?
                                            UserLanguage.of(context).label("open")
                                            : UserLanguage.of(context).label("close"),
                                        style: TextStyle(
                                          color: detailPlace.extended.openingHours.isOpen ? Colors.white : Color(0xff252525),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11
                                        ),
                                      ),
                                    )
                                  :Container()
                                :Container()
                              ],
                            ),
                          ),

                          GestureDetector(
                            onTap: () async{
                               if(await canLaunch(detailPlace.view)){
                                 launch(detailPlace.view,
                                    forceSafariVC: false,
                                    forceWebView: false
                                 );
                               }
                            },
                            child: Container(
                              width: 150,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  topLeft: Radius.circular(30)
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[

                                   Container(
                                     width: 40,
                                     height: 40,
                                     decoration: BoxDecoration(
                                       shape: BoxShape.circle,
                                       color: Theme.of(context).highlightColor
                                     ),
                                     child: Center(
                                       child: Icon(
                                         Icons.map,
                                         color: Theme.of(context).buttonColor,
                                         size: 20,
                                       ),
                                     ),
                                   ),

                                   Flexible(
                                     child: Padding(
                                       padding: const EdgeInsets.only(left: 10, right: 15),
                                       child: Text(
                                         UserLanguage.of(context).label("lookOnMap"),
                                         style: Theme.of(context).primaryTextTheme.body1,
                                       ),
                                     ),
                                   )

                                ],
                              ),
                            ),
                          )

                        ],
                      ),
                    )
                  ],
                )
              ) : Container(),

            viewState == 0 ?
              Positioned(
                bottom: 0,
                left: 0,
                child: BottomDetailPlaces(
                  place: detailPlace,
                  animate: animateExplorer,
                  currentOffsetPercent: currentOffsetPercent,
                  isOpen: isdetailExpand,
                  distance: widget.place.distance,
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
              ) : Container(),

            viewState != 0 ?
              Positioned.fill(
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).highlightColor,
                  highlightColor: ColorCollections.shimmerHighlightColor,
                  child: Stack(
                    children: <Widget>[

                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 35 + MediaQuery.of(context).padding.bottom,
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)
                            )
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 60,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[

                            Container(
                              width: MediaQuery.of(context).size.width-100,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              width: MediaQuery.of(context).size.width-140,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              width: MediaQuery.of(context).size.width-160,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white
                              ),
                            )
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              ) : Container(),

            viewState == 2 ? 
              Positioned.fill(
                child: ErrorPlaceholder(
                  title: CommonHelper.instance.getTitleErrorByCode(context: context, code : statusCoe),
                  desc : CommonHelper.instance.getDescErrorByCode(context : context, code : statusCoe),
                  buttonText: UserLanguage.of(context).button("retry") ,
                  isNeedButton: true,
                  callback: (){
                    if(mounted){
                      setState(() {
                        isAlreadyReqeust = false;
                        viewState = 1;
                        initiateData();
                      });
                    }
                  },
                )
              )
            :Container(),


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
  onSuccessResponseFailed(Response res) {
    if(res.statusCode== ConstantCollections.STATUS_CODE_UNAUTHORIZE){
      if(!isAlreadyReqeust){
        Timer(const Duration(seconds: 2), (){
           // request back
           isAlreadyReqeust = true;
           initiateData();
        });
      }else{
        if(mounted){
          setState(() {
            isAlreadyReqeust = false;
            viewState = 2;
            statusCoe = res.statusCode;
          });
        }
      }
    }else{
      if(mounted){
        setState(() {
          isAlreadyReqeust = false;
          viewState = 2;
          statusCoe = res.statusCode;
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