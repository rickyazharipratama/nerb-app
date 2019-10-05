import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/PresenterViews/DetailPlaceView.dart';
import 'package:nerb/Presenters/DetailPlacePresenter.dart';
import 'package:nerb/Views/Components/Images/ImagePlaceholder.dart';
import 'package:nerb/Views/Components/misc/BottomDetailPlaces.dart';
import 'package:nerb/Views/Components/misc/ErrorPlaceholder.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPlaces extends StatefulWidget {
  final DetailNearbyPlaceResponse place;
  final String img;
  final DetailPlacePresenter detailPlacePresenter = DetailPlacePresenter();

  DetailPlaces({@required this.place , this.img});
  @override
  _DetailPlacesState createState() => new _DetailPlacesState();
}

class _DetailPlacesState extends State<DetailPlaces> with TickerProviderStateMixin,DetailPlaceView{



  @override
  void initState() {
    super.initState();
    debugPrint("src image : " + widget.img);
    if(widget.img == null){
      setImg = CommonHelper.instance.getPlaceImageByCategory(category: widget.place.category.id);
      if(img == null){
        if(widget.place.category.title.contains("/")){
          List<String> plcs = widget.place.category.title.split("/");
          for(int i= 0; i < plcs.length; i++){
            setImg = CommonHelper.instance.getPlaceImageByCategory(category: plcs[i].toLowerCase());
            if(img != null){
              i = plcs.length;
            }
          }
        }else{
          setImg = CommonHelper.instance.getPlaceImageByCategory(category: widget.place.category.title.toLowerCase());
        }
      }
    }else{
      setImg = widget.img;
    }
    widget.detailPlacePresenter.setView = this;
    widget.detailPlacePresenter.setHref = widget.place.href;
    widget.detailPlacePresenter.initiateData();
  }

  @override
  void onAnimationListening() {
    super.onAnimationListening();
    debugPrint(anim.value.toString());
    setOffset = anim.value;
    setCurrentOffsetPercent = max(0, min(1,offset/((MediaQuery.of(context).size.height - 100)-35)));
    if(mounted){
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async{
          if(isDetailExpanded){
            animationExplorer(context,
              isOpen: false,
              tick: this
            );
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
                  if(isDetailExpanded){
                    animationExplorer(context,
                      isOpen: false,
                      tick: this
                    );
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
                        widget.detailPlacePresenter.response.name,
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
                                    widget.detailPlacePresenter.response.location.address.text.replaceAll("<br/>", "\n"),
                                    maxLines: 4,
                                    style: Theme.of(context).textTheme.body2,
                                  ),
                                ),

                                widget.detailPlacePresenter.response.extended != null ?
                                  widget.detailPlacePresenter.response.extended.openingHours != null ?
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: widget.detailPlacePresenter.response.extended.openingHours.isOpen ? Colors.green : Colors.grey
                                      ),
                                      child: Text(
                                          widget.detailPlacePresenter.response.extended.openingHours.isOpen ?
                                            UserLanguage.of(context).label("open")
                                            : UserLanguage.of(context).label("close"),
                                        style: TextStyle(
                                          color: widget.detailPlacePresenter.response.extended.openingHours.isOpen ? Colors.white : Color(0xff252525),
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
                               if(await canLaunch(widget.detailPlacePresenter.response.view)){
                                 launch(widget.detailPlacePresenter.response.view,
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
                  place: widget.detailPlacePresenter.response,
                  animate: (val){
                    animationExplorer(context,
                      isOpen: val,
                      tick: this
                    );
                  },
                  currentOffsetPercent: currentOffsetPercent,
                  isOpen: isDetailExpanded,
                  distance: widget.place.distance,
                  onVerticalDrugUpdate: (DragUpdateDetails details){
                    setOffset = offset - details.delta.dy;
                    if(offset > MediaQuery.of(context).size.height - 100){
                      setOffset = MediaQuery.of(context).size.height - 100;
                    }else if (offset < 0){
                      setOffset = 0;
                    }
                    if(mounted){
                      setState(() {
                        
                      });
                    }
                  },
                  panDown:() => animationController?.stop(),
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
                  title: CommonHelper.instance.getTitleErrorByCode(context: context, code : widget.detailPlacePresenter.statusCode),
                  desc : CommonHelper.instance.getDescErrorByCode(context : context, code : widget.detailPlacePresenter.statusCode),
                  buttonText: UserLanguage.of(context).button("retry") ,
                  isNeedButton: true,
                  callback: (){
                    if(mounted){
                      setState(() {
                        widget.detailPlacePresenter.reloadRequest();
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
  BuildContext getCurrentContext() {
    return context;
  }

  @override
  void onError() {
    super.onError();
    if(mounted){
      setState(() {
      });
    }
  }

  @override
  void onSuccess() {
    super.onSuccess();
    if(mounted){
      setState(() {
      });
    }
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }
}