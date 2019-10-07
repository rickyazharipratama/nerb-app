import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/DistanceHelper.dart';
import 'package:nerb/Collections/FirebaseAnalyticHelper.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/PresenterViews/Components/Collections/Items/DetailPlaceItemView.dart';
import 'package:nerb/Presenters/Components/Collections/Items/DetailPlaceItemPresenter.dart';
import 'package:nerb/Views/Components/Images/ImagePlaceholder.dart';
import 'package:nerb/Views/Pages/DetailPlaces.dart';

class DetailPlace extends StatefulWidget {

  final DetailNearbyPlaceResponse place;
  final double mode;

  DetailPlace({@required this.place, this.mode:0});

  @override
  _DetailPlaceState createState() => new _DetailPlaceState();
}

class _DetailPlaceState extends State<DetailPlace> with DetailPlaceItemView{

  DetailPlaceItemPresenter presenter = DetailPlaceItemPresenter();

  @override
  void initState() {
    super.initState();
    presenter.setView = this;
    presenter.setDetailNearbyPlace = widget.place;
    presenter.setMode = widget.mode;
  }

  @override
  BuildContext currentContext() => context;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FirebaseAnalyticHelper.instance.sendEvent(
          event: ConstantCollections.EVENT_OPEN_DETAIL_PLACES_BY_PLACE_LIST,
          params: {
            "date": DateTime.now().toString(),
            "category":widget.place.category != null ? widget.place.category.id != null ? widget.place.category.id : "-" : "-",
            "name":widget.place.title
          }
        );
        NerbNavigator.instance.push(context,
          child: DetailPlaces(
            place: widget.place,
            img : presenter.img
          )
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: widget.mode == 0 ? ((MediaQuery.of(context).size.width - 20) * 9 / 16 ) +80
        : ((((MediaQuery.of(context).size.width - 25) / 2) * 16) / 9) + 110,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Expanded(
              child: Hero(
                tag: "detailImage-"+widget.place.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: presenter.img != null ? Image.asset(
                    presenter.img,
                    fit: BoxFit.cover,
                    color: ColorCollections.wrapperCategory,
                    colorBlendMode: BlendMode.srcATop,
                    height: getHeight(presenter.mode),
                    width: getWidth(presenter.mode)
                  )
                  : Container(
                    height: getHeight(presenter.mode),
                    width: getWidth(presenter.mode),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).highlightColor
                    ),
                    child: ImagePlaceholder(),
                  ),
                ),
              ),
            ),
            
            Container(
              height: widget.mode == 0  ? 80 : 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                    child: Text(
                      widget.place.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).primaryTextTheme.subhead,
                    ),
                  ),

                  placeDescription(context)
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget placeDescription(context){
    return widget.mode == 0 ? Row(
      children: <Widget>[
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.room,
                color: Theme.of(context).buttonColor,
                size: 25, 
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    widget.place.vicinity,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).primaryTextTheme.body1,
                  ),
                ),
              ),
            ],
          )
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.directions,
              color: Theme.of(context).buttonColor,
              size: 25, 
            ),

            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                DistanceHelper.instance.getFormatDistance(context, (widget.place.distance.toDouble()/1000)),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).primaryTextTheme.body1,
              ),
            )
          ],
        )
      ],
    ) : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.room,
              color: Theme.of(context).buttonColor,
              size: 25, 
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  widget.place.vicinity,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).primaryTextTheme.body1,
                ),
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.directions,
              color: Theme.of(context).buttonColor,
              size: 25, 
            ),

            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                DistanceHelper.instance.getFormatDistance(context, widget.place.distance.toDouble()/1000),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).primaryTextTheme.body1,
              ),
            )
          ],
        )
      ],
    );
  }
}