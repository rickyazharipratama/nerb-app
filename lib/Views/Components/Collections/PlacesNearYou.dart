import 'package:flutter/material.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/PresenterViews/Components/Collections/PlaceNearYouView.dart';
import 'package:nerb/Presenters/Components/Collections/PlaceNearYouPresenter.dart';
import 'package:nerb/Views/Components/Buttons/FlexibleButton.dart';
import 'package:nerb/Views/Components/Collections/Items/PlaceNearYouItem.dart';
import 'package:nerb/Views/Components/Labels/SectionTitle.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerPlaceNearYou.dart';
import 'package:nerb/Views/Components/misc/WrapperError.dart';
import 'package:nerb/Views/Pages/Places.dart';

class PlacesNearYou extends StatefulWidget {

  PlacesNearYou();

  @override
  _PlacesNearYouState createState() => new _PlacesNearYouState();
}

class _PlacesNearYouState extends State<PlacesNearYou> with PlaceNearYouView{

  PlaceNearYouPresenter presenter = PlaceNearYouPresenter();

  @override
  void initState() {
    super.initState();
    presenter.setView = this;
    presenter.initiateData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 7, right: 10),
              child: SectionTitle.withText(
                value: UserLanguage.of(context).title('placesNearYou')
              ),
          ),

          viewState == 0?
          Container(
            height: 230,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: presenter.nearby.nearbyPlaces.map((place){
                if(place.id == ConstantCollections.SEE_ALL){
                  return FlexibleButton(
                    title: UserLanguage.of(context).button("seeAll"),
                    background: Theme.of(context).highlightColor,
                    width: 180,
                    height: 230,
                    callback: (){
                      List<DetailNearbyPlaceResponse> tmp = List();
                      tmp.addAll(presenter.nearby.nearbyPlaces);
                      tmp.removeLast();
                      NerbNavigator.instance.push(context,
                        child: Places(
                          title: UserLanguage.of(context).title('placesNearYou'),
                          forSearch: "-",
                        )
                      );
                    },
                  );
                }
                return PlaceNearYouItem(
                  place: place,
                );
              }).toList(),
            ),
          )
          : Container(
            height: 200,
            child: Stack(
              children: <Widget>[

                Positioned.fill(
                  child: ShimmerPlaceNearYou(),
                ),

                viewState == 2 ?
                  WrapperError(
                    buttonText: UserLanguage.of(context).button("retry"),
                    title: CommonHelper.instance.getTitleErrorByCode(
                      context: context,
                      code: presenter.statusCode
                    ),
                    desc: CommonHelper.instance.getDescErrorByCode(
                      context: context,
                      code: presenter.statusCode
                    ),
                    height: 140,
                    callback: (){
                      if(mounted){
                        setState(() {
                          setViewState = 1;
                          presenter.initiateData();
                        });
                      }
                    },
                  )
                : Container()
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  BuildContext currentContext() => context;

  @override
  void onError(){
    super.onError();
    if(mounted){
      setState(() {
        setViewState = 2;
      });
    }
  }

  @override
  void onSuccess() {
    super.onSuccess();
    if(mounted){
      setState(() {
        CommonHelper.instance.showLog("success fetch nearby place");
        setViewState = 0;
      });
    }
  }
}