import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/DistanceHelper.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/PresenterViews/Components/Collections/Items/DetailPlaceItemView.dart';
import 'package:nerb/Presenters/Components/Collections/Items/DetailPlaceItemPresenter.dart';
import 'package:nerb/Views/Components/Images/ImagePlaceholder.dart';
import 'package:nerb/Views/Pages/DetailPlaces.dart';

class DetailPlace extends StatefulWidget {

  final DetailNearbyPlaceResponse place;
  final double mode;
  final DetailPlaceItemPresenter presenter = DetailPlaceItemPresenter();

  DetailPlace({@required this.place, this.mode:0}){
    presenter.setDetailNearbyPlace = place;
    presenter.setMode = mode;
  }

  @override
  _DetailPlaceState createState() => new _DetailPlaceState();
}

class _DetailPlaceState extends State<DetailPlace> with DetailPlaceItemView{

  @override
  void initState() {
    super.initState();
    widget.presenter.setView = this;
  }

  @override
  BuildContext currentContext() => context;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        NerbNavigator.instance.push(context,
          child: DetailPlaces(
            place: widget.place,
            img : widget.presenter.img
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
                  child: widget.presenter.img != null ? Image.asset(
                    widget.presenter.img,
                    fit: BoxFit.cover,
                    color: ColorCollections.wrapperCategory,
                    colorBlendMode: BlendMode.srcATop,
                    height: getHeight(widget.presenter.mode),
                    width: getWidth(widget.presenter.mode)
                  )
                  : Container(
                    height: getHeight(widget.presenter.mode),
                    width: getWidth(widget.presenter.mode),
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