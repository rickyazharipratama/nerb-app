import 'package:nerb/PresenterViews/PlaceByCategoryView.dart';
import 'package:nerb/Presenters/BasePresenter.dart';

class PlaceByCategoryPresenter extends BasePresenter{

  PlaceByCategoryView _view;

  PlaceByCategoryView get view => _view;
  set setView(PlaceByCategoryView vw){_view = vw;}
}