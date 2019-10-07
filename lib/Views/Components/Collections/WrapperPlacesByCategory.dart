import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/PresenterViews/Components/Collections/WrapperPlacesByCategoryView.dart';
import 'package:nerb/Presenters/Components/Collections/WrapperPlacesByCategoryPresenter.dart';
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

class _WrapperPlacesBycategoryState extends State<WrapperPlacesBycategory> with WrapperPlacesByCategoryView{

  WrapperPlacesByCategoryPresenter presenter;
  
  @override
  void initState() {
    super.initState();
    presenter = WrapperPlacesByCategoryPresenter(
      category: widget.category
    );
    presenter.setView = this;
    presenter.initiateData();
  }

  @override
  Widget build(BuildContext context) {
    return viewState == 0 ?
      presenter.places.length > 0 ?
        ListView(
          children: presenter.sections.map((sct){
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? sct.id : sct.en,
                      style: Theme.of(context).primaryTextTheme.subhead,
                    ),
                  ),

                  Wrap(
                    spacing: 10,
                    runSpacing: 15,
                    children: presenter.places.where((plc) => plc.section.id == sct.id && plc.section.en == sct.en).map((place){
                      return PlaceItem(
                        place: place,
                        callback: presenter.goToPlaces
                      );
                    }).toList(),
                  )
                ],
              ),
            );
          }).toList(),
        )
      : ErrorPlaceholder(
          title: UserLanguage.of(context).errorTitle("typePlaceEmpty"),
          desc: UserLanguage.of(context).errorDesc("typePlaceEmpty"),
          isNeedButton: false,
      )
    : viewState == 2 ? ErrorPlaceholder(
      title: CommonHelper.instance.getTitleErrorByCode(
        code: presenter.statusCode,
        context: context
      ),
      desc: CommonHelper.instance.getDescErrorByCode(
        code: presenter.statusCode,
        context: context
      ),
      buttonText: UserLanguage.of(context).button("retry"),
      callback: (){
        setViewState = 1;
        presenter.initiateData();
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

  @override
  BuildContext currentContext() => context;

  @override
  onSuccess(){
    super.onSuccess();
    if(mounted){
      setState(() {
        setViewState = 0;
      });
    }
  }

  @override
  void onError() {
    super.onError();
    if(mounted){
      setState(() {
        setViewState = 2;
      });
    }
  }
}