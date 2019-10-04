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
  

}