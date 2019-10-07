import 'package:nerb/Collections/ConstantCollections.dart';
import 'package:nerb/Collections/FirebaseAnalyticHelper.dart';
import 'package:nerb/Models/FirestoreCategory.dart';
import 'package:nerb/PresenterViews/Components/Collections/Items/CategoryItemView.dart';
import 'package:nerb/Presenters/Components/BaseComponentPresenter.dart';

class CategoryItemPresenter extends BaseComponentPresenter{

  CategoryItemView _view;
  FirestoreCategory _category;
  String _image;

  CategoryItemView get view => _view;
  set setView(CategoryItemView vw){
    _view = vw;
  }

  FirestoreCategory get category => _category;
  set setCategory(FirestoreCategory cat){
    _category = cat;
  }

  String get image => _image;
  set setImage(String img){
    _image = img;
  }
  
  goToCategorySection(){
    FirebaseAnalyticHelper.instance.sendEvent(
      event: ConstantCollections.EVENT_OPEN_SECTION_BY_CATEGORY,
      params: {
        "date":DateTime.now().toString(),
        "category":category.name
      }
    );
    view.goToPlacesByCategory(category);
  }

}