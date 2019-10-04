import 'package:nerb/Collections/CommonHelper.dart';
import 'package:nerb/Models/Response/DetailNearbyPlaceResponse.dart';
import 'package:nerb/PresenterViews/Components/Collections/Items/DetailPlaceItemView.dart';
import 'package:nerb/Presenters/Components/BaseComponentPresenter.dart';

class DetailPlaceItemPresenter extends BaseComponentPresenter{

  DetailPlaceItemView _view;
  DetailNearbyPlaceResponse _detailNearbyPlace;
  double _mode;
  
  DetailPlaceItemView get view => _view;
  set setView(DetailPlaceItemView vw){
    _view = vw;
  }

  DetailNearbyPlaceResponse get detailNearbyPlace => _detailNearbyPlace;
  set setDetailNearbyPlace(DetailNearbyPlaceResponse nerb){
    _detailNearbyPlace = nerb;
  }

  double get mode => _mode;
  set setMode(double md){
    _mode = md;
  }

  String get img{
    String image = CommonHelper.instance.getPlaceImageByCategory(
      category: detailNearbyPlace.category.id
    );
    if(image == null){
      if(detailNearbyPlace.category.title.contains("/")){
        List<String> plcs = detailNearbyPlace.category.title.split("/");
        for(int i= 0; i < plcs.length; i++){
          image = CommonHelper.instance.getPlaceImageByCategory(category: plcs[i].toLowerCase());
          if(image != null){
            i = plcs.length;
          }
        }
      }else{
        image = CommonHelper.instance.getPlaceImageByCategory(category: detailNearbyPlace.category.title.toLowerCase());
      }
    }
    return image;
  }

}