import 'package:flutter/material.dart';
import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/PresenterViews/Components/Collections/RelatedView.dart';
import 'package:nerb/Presenters/Components/Collections/RelatedPresenter.dart';
import 'package:nerb/Views/Components/Collections/Items/PlaceNearYouItem.dart';
import 'package:nerb/Views/Components/Shimmers/ShimmerPlaceNearYou.dart';
import 'package:nerb/Views/Components/misc/WrapperError.dart';

class Related extends StatefulWidget {

  final String href;
  final String type;
  Related({@required this.href, this.type});

  @override
  _RelatedState createState() => new _RelatedState();
}

class _RelatedState extends State<Related> with RelatedView{

  RelatedPresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = RelatedPresenter(
      href: widget.href,
      type: widget.type
    );
    presenter.setView = this;
    presenter.initiateData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      width: MediaQuery.of(context).size.width,
      height: 230,
      child: viewState == 0 ?
        ListView(
          shrinkWrap: true,
          addRepaintBoundaries: true,
          scrollDirection: Axis.horizontal,
          children: presenter.places.nearbyPlaces.map((plc){
            return PlaceNearYouItem(
              place: plc,
              callback: (){
                presenter.goToDetailPlace(plc);
              },
            );
          }).toList(),
        )
        : Stack(
          children: <Widget>[
            Positioned.fill(
              child: ShimmerPlaceNearYou(),
            ),

            viewState == 2 ?
            Positioned.fill(
              child: WrapperError(
                title: CommonHelper.instance.getTitleErrorByCode(context: context, code: presenter.statusCode),
                desc: CommonHelper.instance.getDescErrorByCode(context: context, code: presenter.statusCode),
                buttonText: UserLanguage.of(context).button("retry"),
                height: 230,
                callback: (){
                  if(mounted){
                    setState(() {
                      presenter.setAlreadyRequired = false;
                      setViewState = 1;
                      presenter.initiateData();
                    });
                  }
                },
              ),
            )
            : Container()
          ],
        )
      ,
    );
  }

  @override
  void onSuccess(){
    super.onSuccess();
    if(mounted){
      setState(() {
        setViewState = 0;
      });
    }
  }

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
  void notifyState() {
    super.notifyState();
  }

  @override
  BuildContext currentContext() => context;

}