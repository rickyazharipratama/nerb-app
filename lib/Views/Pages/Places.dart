import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/PresenterViews/PlaceView.dart';
import 'package:nerb/Presenters/PlacePresenter.dart';
import 'package:nerb/Views/Components/Collections/Items/DetailPlace.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerGridPlaces.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerListPlaces.dart';
import 'package:nerb/Views/Components/misc/ErrorPlaceholder.dart';
import 'package:nerb/Views/Components/misc/NerbPushAppBar.dart';

class Places extends StatefulWidget {

  final String title;
  final String forSearch;
  final PlacePresenter presenter = PlacePresenter();

  Places({@required this.title, @required this.forSearch}){
    presenter.setForSearch = forSearch;
  }

  @override
  _PlacesState createState() => new _PlacesState();
}

class _PlacesState extends State<Places> with PlaceView{

  @override
  void initState() {
    super.initState();
    widget.presenter.setView = this;
    setScrollController = widget.presenter.requestAffectByScroll;
    widget.presenter.initiateData();
  }

  @override
  BuildContext currentContext() {
    return context;
  }

  @override
  void onEndScrolling() {
    if(mounted){
      setState(() {
         widget.presenter.getPlaceRequestByScroll();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CommonHelper.instance.forcePortraitOrientation();
    return Material(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          NerbPushAppBar(
            title: widget.title,
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                viewState == 0 ?
                  widget.presenter.response.nearbyPlaces.length > 0?
                    Positioned.fill(
                      child: mode == 0 ?
                          ListView(
                            controller: scrollController,
                            children: widget.presenter.response.nearbyPlaces.map((place){
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
                          controller: scrollController,
                          children: widget.presenter.response.nearbyPlaces.map((place){
                            return DetailPlace(
                              place: place,
                              mode: 1,
                            );
                          }).toList(),
                        )
                      :  Container()
                    )
                    : Stack(
                      children: <Widget>[
                          Positioned.fill(
                            child: ShimmerListPlaces(),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: ErrorPlaceholder(
                                title: UserLanguage.of(context).title("aw"),
                                desc: UserLanguage.of(context).desc("emptyPlace"),
                                isNeedButton: false,
                                icon: Icons.location_off,
                              ),
                            ),
                          )
                      ],
                    )
                : Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: mode == 0 ?
                        ShimmerListPlaces()
                        : mode == 1 ?
                          ShimmerGridPlaces()
                        : Container(),
                      ),
                     viewState == 2 ?
                      Positioned.fill(
                        child: ErrorPlaceholder(
                          title: CommonHelper.instance.getTitleErrorByCode(
                            code: widget.presenter.statusCode,
                            context: context
                          ),
                          desc: CommonHelper.instance.getDescErrorByCode(
                            code: widget.presenter.statusCode,
                            context: context
                          ),
                          isNeedButton: true,
                          buttonText: UserLanguage.of(context).button('retry'),
                          callback: (){
                            widget.presenter.setAlreadyRetry = false;
                            if(mounted){
                              setState(() {
                                setViewState = 1;
                                widget.presenter.initiateData();
                              });
                            }
                          },
                        )
                      )
                     :Container()
                  ],
                ),
                viewState == 0 ?
                widget.presenter.response.nearbyPlaces.length > 0 ?
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
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
                                    setMode = 0;
                                  });
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                              decoration: BoxDecoration(
                                color: mode == 0 ? Theme.of(context).buttonColor : Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10)
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 1.5,
                                    color: Theme.of(context).buttonColor,
                                    offset: Offset(1.5,3)
                                  )
                                ],
                              ),
                              child: Icon(
                                Icons.menu,
                                size: 20,
                                color: getIconColor(),
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: (){
                              if(mode != 1){
                                if(mounted){
                                  setState(() {
                                    setMode = 1;
                                  });
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(30,5,30,5),
                              decoration: BoxDecoration(
                                color: mode == 1 ? Theme.of(context).buttonColor : Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 1.5,
                                    color: Theme.of(context).buttonColor,
                                    offset: Offset(-1.5,3)
                                  )
                                ]
                              ),
                              child: Icon(
                                Icons.view_module,
                                size: 20,
                                color: Theme.of(context).brightness == Brightness.light ? mode == 1 ? Colors.white : Theme.of(context).primaryTextTheme.body1.color : mode == 1 ? Color(0xff585858) : Theme.of(context).primaryTextTheme.body1.color,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          )
                        ],
                      ),
                  ) : Container() : Container()
              ],
            ),
          ),
          AnimatedCrossFade(
            crossFadeState: widget.presenter.requestMode == 1 && widget.presenter.isProcessRequest ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Container(
              padding: EdgeInsets.only(top: 5, bottom: MediaQuery.of(context).padding.bottom + 10),
              child: Center(
                child: SpinKitThreeBounce(
                  color: Theme.of(context).buttonColor,
                  size: 20,
                ),
              ),
            ),
            secondChild: Container(),
            duration: const Duration(milliseconds: 300),
          )
        ],
      ),
    ); 
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onError() {
    super.onError();
    if(mounted){
      setState(() {
        if(widget.presenter.requestMode == 0){
          setViewState= 2;
        }
      });
    }
  }

  @override
  void onSuccess() {
    super.onSuccess();
    if(mounted){
      setState(() {
        setViewState = 0;
      });
    }
  }
}