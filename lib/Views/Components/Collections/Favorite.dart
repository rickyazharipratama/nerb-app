import 'package:flutter/material.dart';
import 'package:nerb/Collections/ColorCollections.dart';
import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/NerbNavigator.dart';
import 'package:nerb/Collections/translations/UserLanguage.dart';
import 'package:nerb/Models/PlaceModel.dart';
import 'package:nerb/PresenterViews/Components/Collections/FavoriteView.dart';
import 'package:nerb/Presenters/Components/FavoritePresenter.dart';
import 'package:nerb/Views/Components/Collections/Items/AddFavoritesItem.dart';
import 'package:nerb/Views/Components/Collections/Items/EditPlaceItem.dart';
import 'package:nerb/Views/Components/Labels/SectionTitle.dart';
import 'package:nerb/Views/Components/Shimmers/ShimerFavorite.dart';
import 'package:nerb/Views/Components/misc/Separator.dart';
import 'package:nerb/Views/Pages/Places.dart';

import 'Items/PlaceItem.dart';

class Favorite extends StatefulWidget {

  final VoidCallback openingPlace;
  final VoidCallback closingPlace;
  final bool isCategoryRetrieve;

  Favorite({@required this.openingPlace, @required this.closingPlace,  this.isCategoryRetrieve : false});

  @override
  _FavoriteState createState() => new _FavoriteState();
}

class _FavoriteState extends State<Favorite> with FavoriteView{

  FavoritePresenter presenter = FavoritePresenter();

  @override
  void initState() {
    super.initState();
      presenter.setView = this;
      presenter.setOpeningPlace = widget.openingPlace;
      presenter.setClosingPlace = widget.closingPlace;
      presenter.initiateData();
    }
    
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: SectionTitle.withText(
                value: UserLanguage.of(context).title("favorite"),
              ),
            ),

          Separator(),

            Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: widget.isCategoryRetrieve ?
                viewState == 0 ? 
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: presenter.favorites.getRange(0, 4).map((fav){
                        return fav.id.startsWith(ConstantCollections.EMPTY_FAVORITE) ?
                            AddFavoritesItem(
                              callback: presenter.showPlaceList,
                              place: fav,
                            )
                            : isEditMode ?
                                EditPlaceItem(
                                  onDeleteClick: presenter.onDeletePlaceClicked,
                                  place: fav,
                                )
                              : PlaceItem(
                                place: fav,
                                callback: (place){
                                  NerbNavigator.instance.push(context,
                                    child: Places(
                                      title: UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? place.name.id : place.name.en,
                                      forSearch: place.forSearch,
                                    )
                                  );
                                },
                              );
                      }).toList(),
                    ),

                    Padding(padding: const EdgeInsets.only(top: 10)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: presenter.favorites.getRange(4, presenter.favorites.length).map((fav){
                        
                        return fav.id.startsWith(ConstantCollections.EMPTY_FAVORITE) ? 
                              AddFavoritesItem(
                                callback: presenter.showPlaceList,
                                place: fav,
                              )
                            : fav.id == ConstantCollections.OPERATOR_FAVORITE ?
                              InkWell(
                                onTap: isEditMode ? presenter.turnOffEditMode : presenter.turnOnEditMode,
                                borderRadius: BorderRadius.circular(25),
                                splashColor: ColorCollections.shimmerHighlightColor,
                                highlightColor: ColorCollections.shimmerBaseColor,
                                child: Container(
                                  width: 65,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isEditMode ? Colors.red : Theme.of(context).highlightColor,
                                      width: 1,
                                    ),
                                    color: isEditMode ? Colors.red : Theme.of(context).highlightColor,
                                    shape: BoxShape.circle
                                  ),
                                  child: Center(
                                    child: Icon(
                                      isEditMode ? Icons.close : Icons.edit,
                                      color: isEditMode ? Colors.white : Theme.of(context).buttonColor,
                                      size: 25,
                                    ),
                                  )
                                ),
                              )
                              : isEditMode ?
                                EditPlaceItem(
                                  onDeleteClick: presenter.onDeletePlaceClicked,
                                  place: fav,
                                )
                                : PlaceItem(
                                    place: fav,
                                    callback: (place){
                                      NerbNavigator.instance.push(context,
                                        child: Places(
                                          title: UserLanguage.of(context).currentLanguage == ConstantCollections.LANGUAGE_ID ? place.name.id : place.name.en,
                                          forSearch: place.forSearch,
                                        )
                                      );
                                    },
                                  );
                      }).toList(),
                    )
                  ],
                )
                : ShimmerFavorite()
              : ShimmerFavorite(),
            ),
            Separator()
        ],
      ),
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

  @override
  void notifyState(){
    super.notifyState();
    if(mounted){
      setState(() {});
    }
  }
}